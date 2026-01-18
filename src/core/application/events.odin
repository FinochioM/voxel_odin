package application

import  "vendor:glfw"

Event_Queue : ^[dynamic]Event

event_system_init :: proc(window: glfw.WindowHandle, event_queue: ^[dynamic]Event) {
    Event_Queue = event_queue

    glfw.SetKeyCallback(window, key_callback)
    glfw.SetWindowSizeCallback(window, window_size_callback)
    glfw.SetMouseButtonCallback(window, mouse_callback)
    glfw.SetScrollCallback(window, scroll_callback)
    glfw.SetCursorPosCallback(window, cursor_pos_callback)
    glfw.SetFramebufferSizeCallback(window, framebuffer_size_callback)
}

key_callback :: proc "c"(window: glfw.WindowHandle, key, scan_code, action, mods: i32) {

}

window_size_callback :: proc "c"(window: glfw.WindowHandle, width, height: i32) {

}

mouse_callback :: proc "c"(window: glfw.WindowHandle, button, action, mods: i32) {

}

scroll_callback :: proc "c"(window: glfw.WindowHandle, xoffset, yoffset: f64) {

}

cursor_pos_callback :: proc "c"(window: glfw.WindowHandle, xpos, ypos: f64) {

}

framebuffer_size_callback :: proc "c"(window: glfw.WindowHandle, width, height: i32) {

}