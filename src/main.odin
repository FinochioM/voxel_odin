package main

import opcl "opengl_classes"

import "core:fmt"
import m "core:math/linalg/glsl"

import "vendor:glfw"
import op "vendor:OpenGL"

WIDTH :: 800
HEIGHT :: 600
GL_MAJOR_VERSION :: 3
GL_MINOR_VERSION :: 3

main :: proc() {
    glfw.Init()
    glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, GL_MAJOR_VERSION)
    glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, GL_MINOR_VERSION)
    glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)

    window := glfw.CreateWindow(WIDTH, HEIGHT, "voxel odin", nil, nil)

    if window == nil {
        fmt.println("Failed to create GLFW window")
        glfw.Terminate()
        return
    }

    glfw.MakeContextCurrent(window)

    glfw.SetFramebufferSizeCallback(window, size_callback)

    op.load_up_to(int(GL_MAJOR_VERSION), int(GL_MINOR_VERSION), glfw.gl_set_proc_address)

    glfw.SwapInterval(1)

    op.Enable(op.DEPTH_TEST) // enable depth

    ourShader : opcl.Shader
    ourShader = opcl.shader_init_from_file("src/shaders/vertex.glsl", "src/shaders/fragment.glsl")
    opcl.compile_shaders(&ourShader)

    vertices := []f32 {
        -0.5, -0.5, -0.5,  0.0, 0.0,
        0.5, -0.5, -0.5,  1.0, 0.0,
        0.5,  0.5, -0.5,  1.0, 1.0,
        0.5,  0.5, -0.5,  1.0, 1.0,
        -0.5,  0.5, -0.5,  0.0, 1.0,
        -0.5, -0.5, -0.5,  0.0, 0.0,

        -0.5, -0.5,  0.5,  0.0, 0.0,
        0.5, -0.5,  0.5,  1.0, 0.0,
        0.5,  0.5,  0.5,  1.0, 1.0,
        0.5,  0.5,  0.5,  1.0, 1.0,
        -0.5,  0.5,  0.5,  0.0, 1.0,
        -0.5, -0.5,  0.5,  0.0, 0.0,

        -0.5,  0.5,  0.5,  1.0, 0.0,
        -0.5,  0.5, -0.5,  1.0, 1.0,
        -0.5, -0.5, -0.5,  0.0, 1.0,
        -0.5, -0.5, -0.5,  0.0, 1.0,
        -0.5, -0.5,  0.5,  0.0, 0.0,
        -0.5,  0.5,  0.5,  1.0, 0.0,

        0.5,  0.5,  0.5,  1.0, 0.0,
        0.5,  0.5, -0.5,  1.0, 1.0,
        0.5, -0.5, -0.5,  0.0, 1.0,
        0.5, -0.5, -0.5,  0.0, 1.0,
        0.5, -0.5,  0.5,  0.0, 0.0,
        0.5,  0.5,  0.5,  1.0, 0.0,

        -0.5, -0.5, -0.5,  0.0, 1.0,
        0.5, -0.5, -0.5,  1.0, 1.0,
        0.5, -0.5,  0.5,  1.0, 0.0,
        0.5, -0.5,  0.5,  1.0, 0.0,
        -0.5, -0.5,  0.5,  0.0, 0.0,
        -0.5, -0.5, -0.5,  0.0, 1.0,

        -0.5,  0.5, -0.5,  0.0, 1.0,
        0.5,  0.5, -0.5,  1.0, 1.0,
        0.5,  0.5,  0.5,  1.0, 0.0,
        0.5,  0.5,  0.5,  1.0, 0.0,
        -0.5,  0.5,  0.5,  0.0, 0.0,
        -0.5,  0.5, -0.5,  0.0, 1.0
    }

    cube_positions := []m.vec3 {
        m.vec3{0.0, 0.0, 0.0},
        m.vec3{2.0, 5.0, -15.0},
        m.vec3{-1.5, -2.2, -2.5},
        m.vec3{2.4, -0.4, -3.5}
    }

    VBO : opcl.VertexBuffer
    VAO : opcl.VertexArray

    VAO = opcl.vertex_array_init()
    VBO = opcl.vertex_buffer_init(op.ARRAY_BUFFER)

    opcl.vertex_array_bind(&VAO)
    opcl.vertex_buffer_buffer_data(&VBO, len(vertices)*size_of(f32), rawptr(&vertices[0]), op.STATIC_DRAW)

    opcl.vertex_attrib_pointer(&VBO, 0, 3, op.FLOAT, op.FALSE, 5 * size_of(f32), 0)
    opcl.vertex_attrib_pointer(&VBO, 1, 2, op.FLOAT, op.FALSE, 5 * size_of(f32), 3 * size_of(f32))

    texture : opcl.Texture
    texture = opcl.texture_init()
    opcl.create_texture(&texture, "src/resources/grass_block.png", op.RGBA, op.TEXTURE_2D, op.NEAREST, op.NEAREST, op.REPEAT, op.REPEAT, texture.tex_coords, true)

    opcl.shader_use(&ourShader)
    opcl.set_integer(&ourShader, "u_Texture", 0, false)

    for (!glfw.WindowShouldClose(window)) {
        process_input(window)

        op.ClearColor(0.2, 0.3, 0.3, 1.0)
        op.Clear(op.COLOR_BUFFER_BIT | op.DEPTH_BUFFER_BIT)

        opcl.texture_bind(&texture, 0)

        opcl.shader_use(&ourShader)

        view := m.mat4(1.0)
        projection := m.mat4(1.0)
        projection = m.mat4Perspective(45.0, f32(WIDTH) / f32(HEIGHT), 0.1, 100.0)

        view = m.mat4Translate(m.vec3{0.0, 0.0, -3.0})
        opcl.set_matrix4(&ourShader, "projection", projection, true)
        opcl.set_matrix4(&ourShader, "view", view, true)

        opcl.vertex_array_bind(&VAO)

        for i := 0; i < len(cube_positions); i += 1 {
            model := m.mat4(1.0)
            model = m.mat4Translate(cube_positions[i])

            angle : f32 = 20.0 * f32(i)
            model = m.mat4Rotate(m.vec3{1.0, 0.3, 0.5}, m.radians_f32(angle))

            opcl.set_matrix4(&ourShader, "model", model, true)

            op.DrawArrays(op.TRIANGLES, 0, 36)
        }

        glfw.SwapBuffers(window)
        glfw.PollEvents()
    }

    glfw.Terminate()
}

size_callback :: proc "c"(window: glfw.WindowHandle, width, height: i32) {
    op.Viewport(0, 0, width, height)
}

process_input :: proc(window: glfw.WindowHandle) {
    if glfw.GetKey(window, glfw.KEY_ESCAPE) == glfw.PRESS {
        glfw.SetWindowShouldClose(window, true)
    }
}