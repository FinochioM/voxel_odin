package core

import m "core:math/linalg/glsl"

import "../core"

Chunk :: struct {
    m_ChunkContents: [16][16][16]Block
}

chunk_add_block :: proc(c: ^Chunk, type: Block_Type, position: m.vec3) {
    b : Block
    b.p_Position = position
    b.p_Chunk = c
    b.p_BlockType = type

    x := int(position.x)
    y := int(position.y)
    z := int(position.z)

    c.m_ChunkContents[x][y][z] = b
}