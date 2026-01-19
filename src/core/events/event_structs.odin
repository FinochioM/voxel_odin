package events

Event_Types :: enum {
    KeyPress = 0,
    KeyRelease,
    MousePress,
    MouseRelease,
    MouseScroll,
    MouseMove,
    WindowResize,
    Undefined,
}

Event :: struct {
    type: Event_Types,
    wx, wy, key, button, mods: i32,
    mx, my, msx, msy, ts: f64,
}