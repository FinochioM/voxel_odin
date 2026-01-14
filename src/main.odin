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

    texture : opcl.Texture
    texture = opcl.texture_init()
    opcl.create_texture(&texture, "src/resources/grass_block.png", op.RGBA, op.TEXTURE_2D, op.NEAREST, op.NEAREST, op.REPEAT, op.REPEAT, texture.tex_coords, true)

    cube_position := m.vec3{0.0, 0.0, 0.0}

    projection := m.mat4(1.0)
    projection = m.mat4Perspective(45.0, f32(WIDTH) / f32(HEIGHT), 0.1, 100.0)
    cb : co.Cube_Renderer
    cb = co.cube_renderer_init()

    angle : f32

    for (!glfw.WindowShouldClose(window)) {
        angle += 0.1
        process_input(window)

        op.ClearColor(0.2, 0.3, 0.3, 1.0)
        op.Clear(op.COLOR_BUFFER_BIT | op.DEPTH_BUFFER_BIT)

        co.cube_renderer_render(&cb, cube_position, &texture, angle, projection)

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