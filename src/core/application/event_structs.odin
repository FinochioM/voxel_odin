package application

Event_Types :: enum {
    KeyPress = 0,
    KeyRelease,
    MousePress,
    MouseRelease,
    MouseScroll,
    MouseMove,
    WindowResize,
}

Event :: struct {
    type: Event_Types,
    wx, wy, key: i32,
    mx, my, msx, msy, ts: f64,
}