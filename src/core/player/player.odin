package player

import m "core:math/linalg/glsl"

import co "../../core"

Player :: struct {
    p_Camera: co.Camera,
    p_Position: m.vec3,
    p_World: rawptr
}

player_set_world :: proc(p: ^Player, w: rawptr) {
    p.p_World = w
}

player_on_update :: proc(p: ^Player) {

}

player_on_event :: proc(p: ^Player) {
    
}