package player

import m "core:math/linalg/glsl"

import co "../../core"

Player :: struct {
    p_Camera: co.Camera,
    p_Position: m.vec3,
    p_World: rawptr
}

player_init :: proc() -> Player {
    p : Player

    p.p_Camera = co.camera_init(45.0, f32(1280) / f32(720), 0.1, 100.0)

    return p
}

player_set_world :: proc(p: ^Player, w: rawptr) {
    p.p_World = w
}

player_on_update :: proc(p: ^Player) {
    p.p_Position = co.get_position(&p.p_Camera)
}

player_on_event :: proc(p: ^Player) {
    
}