package world

import co "../../core"
import ut "../utils"
import m "core:math/linalg/glsl"

generate_chunk :: proc(chunk: ^co.Chunk) {
    for x := 0; x < ut.ChunkSizeX; x += 1 {
        for y := 0; y < 10; y += 1 {
            for z := 0; z < ut.ChunkSizeZ; z += 1{
                if y >= 4 {
                    co.chunk_add_block(chunk, co.Block_Type.Dirt, m.vec3{f32(x), f32(y), f32(z)})
                } else {
                    co.chunk_add_block(chunk, co.Block_Type.Stone, m.vec3{f32(x), f32(y), f32(z)})
                }
            }
        }
    } 
}