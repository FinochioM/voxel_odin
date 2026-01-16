package utils

import m "core:math/linalg/glsl"

Vertex :: struct {
    position: m.vec3,
    texture_coords: m.vec2,
    block_type: f32
}