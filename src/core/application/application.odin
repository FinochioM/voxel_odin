package application

import w "../world"
import co "../../core"
import ev "../events"
import opcl "../../opengl_classes"

import "vendor:glfw"
import op "vendor:OpenGL"

import "core:fmt"

WIDTH :: 1280
HEIGHT :: 720
GL_MAJOR_VERSION :: 3
GL_MINOR_VERSION :: 3

Application :: struct {
    m_World: ^w.World,
    m_EventQueue: [dynamic]ev.Event,
    m_Window: glfw.WindowHandle,
}

application_init :: proc() -> ^Application {
    using op
    app := new(Application)

    glfw.Init()
    glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, GL_MAJOR_VERSION)
    glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, GL_MINOR_VERSION)
    glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)

    app.m_Window = glfw.CreateWindow(WIDTH, HEIGHT, "voxel odin", nil, nil)

    if app.m_Window == nil {
        fmt.println("Failed to create GLFW window")
        glfw.Terminate()
    }

    glfw.MakeContextCurrent(app.m_Window)

    // vsync on
    glfw.SwapInterval(1)
    
    load_up_to(int(GL_MAJOR_VERSION), int(GL_MINOR_VERSION), glfw.gl_set_proc_address)

    glfw.SetInputMode(app.m_Window, glfw.CURSOR, glfw.CURSOR_DISABLED)

    Enable(DEPTH_TEST)
    DepthMask(TRUE)

    app.m_World = new(w.World)
    w.world_init(app.m_World)

    app.m_EventQueue = make([dynamic]ev.Event, 0, 4096)
    ev.event_system_init(app.m_Window, &app.m_EventQueue)

    return app
}

application_on_update :: proc(app: ^Application) {
    application_poll_events(app)

    w.world_on_update(app.m_World, app.m_Window)

    op.ClearColor(0.3, 0.3, 0.3, 1.0)
    op.Clear(op.COLOR_BUFFER_BIT | op.DEPTH_BUFFER_BIT)

    w.world_render_world(app.m_World)

    opcl.display_frame_rate(app.m_Window, "voxel odin - v0.1 ")

    glfw.SwapBuffers(app.m_Window)
    glfw.PollEvents()
}

application_on_event :: proc(app: ^Application, e: ev.Event) {
    w.world_on_event(app.m_World, e)
}

application_poll_events :: proc(app: ^Application) {
    for i := 0; i < len(app.m_EventQueue); i += 1 {
        application_on_event(app, app.m_EventQueue[i])
    }

    clear(&app.m_EventQueue)
}