package player

import m "core:math/linalg/glsl"

import co "../../core"
import w "../world"

Player :: struct {
    p_Camera: co.Camera,
    p_Position: m.vec3,
    p_World: w.World
}