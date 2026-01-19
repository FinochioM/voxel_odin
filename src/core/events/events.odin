package events

import  "vendor:glfw"

import "base:runtime"

Event_Queue : ^[dynamic]Event

event_system_init :: proc(window: glfw.WindowHandle, event_queue: ^[dynamic]Event) {
    if event_queue == nil {
        return
    }
    
    Event_Queue = event_queue

    glfw.SetKeyCallback(window, key_callback)
    glfw.SetMouseButtonCallback(window, mouse_callback)
    glfw.SetScrollCallback(window, scroll_callback)
    glfw.SetCursorPosCallback(window, cursor_pos_callback)
    glfw.SetFramebufferSizeCallback(window, framebuffer_size_callback)
}

key_callback :: proc "c"(window: glfw.WindowHandle, key, scan_code, action, mods: i32) {
    context = runtime.default_context()

    e: Event

    switch action {
        case glfw.PRESS: {
            e.type = Event_Types.KeyPress
            break
        }
        case glfw.RELEASE: {
            e.type = Event_Types.KeyRelease
            break
        }
        case:
            e.type = Event_Types.Undefined
            break
    }

    e.key = key
    e.mods = mods

    _, _ = append_elems(Event_Queue, e)
}

mouse_callback :: proc "c"(window: glfw.WindowHandle, button, action, mods: i32) {
    context = runtime.default_context()

    e: Event

    switch action {
        case glfw.PRESS: {
            e.type = Event_Types.MousePress
            break
        }
        case glfw.RELEASE: {
            e.type = Event_Types.MouseRelease
            break
        }
        case: {
            e.type = Event_Types.Undefined
            break
        }
    }

    e.button = button
    e.mods = mods

    _, _ = append_elems(Event_Queue, e)
}

scroll_callback :: proc "c"(window: glfw.WindowHandle, xoffset, yoffset: f64) {
    context = runtime.default_context()

    e: Event

    e.type = Event_Types.MouseScroll
    e.msx = xoffset
    e.msy = yoffset

    _, _ = append_elems(Event_Queue, e)
}

cursor_pos_callback :: proc "c"(window: glfw.WindowHandle, xpos, ypos: f64) {
    context = runtime.default_context()

    e: Event
    e.type = Event_Types.MouseMove
    e.mx = xpos
    e.my = ypos

    _, _ = append_elems(Event_Queue, e)
}

framebuffer_size_callback :: proc "c"(window: glfw.WindowHandle, width, height: i32) {
    context = runtime.default_context()

    e: Event

    e.type = Event_Types.WindowResize
    e.wx = width
    e.wy = height

    _, _ = append_elems(Event_Queue, e)
}