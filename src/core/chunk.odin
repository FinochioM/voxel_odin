package core

import m "core:math/linalg/glsl"

import ut "utils"

Chunk :: struct {
    m_ChunkContents: ^[ut.ChunkSizeX][ut.ChunkSizeY][ut.ChunkSizeZ]Block,
    m_ChunkMesh: Chunk_Mesh,
    p_Position: m.vec3,
}

chunk_init :: proc(c: ^Chunk) {
    using ut, c
    c.m_ChunkMesh = chunk_mesh_init()
    c.m_ChunkContents = new([ChunkSizeX][ChunkSizeY][ChunkSizeZ]Block)

    for i := 0; i < ChunkSizeX; i += 1 {
        for j := 0; j < ChunkSizeY; j += 1 {
            for k := 0; k < ChunkSizeZ; k += 1 {
                m_ChunkContents[i][j][k].p_BlockType = Block_Type.Air
            }
        }
    }
}

chunk_add_block :: proc(c: ^Chunk, type: Block_Type, position: m.vec3) {
    b : Block
    b.p_Position = position
    b.p_Chunk = c
    b.p_BlockType = type

    x := int(position.x)
    y := int(position.y)
    z := int(position.z)

    if x < 0 || x >= ut.ChunkSizeX ||
    y < 0 || y >= ut.ChunkSizeY ||
    z < 0 || z >= ut.ChunkSizeZ {
        return
    }

    c.m_ChunkContents[x][y][z] = b
}

chunk_add_block_nopos :: proc(c: ^Chunk, block: Block) {
    c.m_ChunkContents[i32(block.p_Position.x)][i32(block.p_Position.y)][i32(block.p_Position.z)] = block
}

chunk_construct :: proc(c: ^Chunk, pos: m.vec3) {
    using c

    chunk_mesh_construct_mesh(&m_ChunkMesh, m_ChunkContents, pos)
}

//get
get_chunk_mesh :: proc(c: ^Chunk) -> Chunk_Mesh{
    using c

    return m_ChunkMesh
}