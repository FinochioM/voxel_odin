package core

import m "core:math/linalg/glsl"

import util "../core/utils"

Block_Type :: enum {
    Dirt = 0,
    Stone,
    Leaf,
    Wood,
    Cactus,
    Water,
    Air
}

Block :: struct {
    p_BlockType: Block_Type,
    p_Position: m.vec3,
    p_Chunk: ^Chunk,
}