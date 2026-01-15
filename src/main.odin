package main

import opcl "opengl_classes"
import co "core"

import "core:fmt"
import m "core:math/linalg/glsl"

import "vendor:glfw"
import op "vendor:OpenGL"

WIDTH :: 800
HEIGHT :: 600
GL_MAJOR_VERSION :: 3
GL_MINOR_VERSION :: 3

cameraPos := m.vec3{0.0, 0.0, 3.0}
caneraFront := m.vec3{0.0, 0.0, -1.0}
caneraUp := m.vec3{0.0, 1.0, 0.0}

main :: proc() {
    using op, m, co, opcl
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

    load_up_to(int(GL_MAJOR_VERSION), int(GL_MINOR_VERSION), glfw.gl_set_proc_address)

    glfw.SwapInterval(1)

    Enable(op.DEPTH_TEST) // enable depth

    texture : Texture
    texture = texture_init()
    create_texture(&texture, "src/resources/grass_block.png", RGBA, TEXTURE_2D, NEAREST, NEAREST, REPEAT, REPEAT, texture.tex_coords, true)
    
    projection := mat4(1.0)
    projection = mat4Perspective(45.0, f32(WIDTH) / f32(HEIGHT), 0.1, 100.0)
    cb : Cube_Renderer
    cb = cube_renderer_init()

    camera : Camera
    camera = camera_init(45.0, f32(WIDTH) / f32(HEIGHT), 0.1, 100.0)

    angle : f32
    block_count := 16

    cube_position := vec3{0.0, 0.0, -4.0}

    for (!glfw.WindowShouldClose(window)) {
        angle += 0.1
        process_input(window)

        ClearColor(0.2, 0.3, 0.3, 1.0)
        Clear(op.COLOR_BUFFER_BIT | op.DEPTH_BUFFER_BIT)

        cube_renderer_render(&cb, cube_position, &texture, angle, get_view_projection(&camera))

        glfw.SwapBuffers(window)
        glfw.PollEvents()
    }

    glfw.Terminate()
}

size_callback :: proc "c"(window: glfw.WindowHandle, width, height: i32) {
    using op
    Viewport(0, 0, width, height)
}

process_input :: proc(window: glfw.WindowHandle) {
    if glfw.GetKey(window, glfw.KEY_ESCAPE) == glfw.PRESS {
        glfw.SetWindowShouldClose(window, true)
    }
}