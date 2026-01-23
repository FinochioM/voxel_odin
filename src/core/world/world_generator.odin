package world

import co "../../core"
import ut "../utils"
import n "../fast_noise"
import s "structures"

import "core:time"
import m "core:math/linalg/glsl"

_world_rng: ut.Random
_world_noise: n.FNL_State
_world_noise_init: bool

_world_height_map: [ut.ChunkSizeX][ut.ChunkSizeY]f32

init_world_noise :: proc() {
    if _world_noise_init {
        return
    }

    _world_noise_init = true

    //seed := u64(time.to_unix_nanoseconds(time.now()))
    seed : u64 = 1569
    _world_rng = ut.random_init(seed)

    noise_seed := ut.random_int(&_world_rng, 4000)

    _world_noise = n.create_state(i32(noise_seed))
    //_world_noise.noise_type = n.Noise_Type.Open_Simplex_2
    _world_noise.frequency = 0.005
}

generate_chunk :: proc(chunk: ^co.Chunk) {
    init_world_noise()

    generated_x : f32 = 0
    generated_y : f32 = 0
    generated_z : f32 = 0

    tree_structure := s.tree_structure_init()

    for x := 0; x < ut.ChunkSizeX; x += 1 {
        for y := 0; y < ut.ChunkSizeY; y += 1 {
            _world_height_map[x][y] = n.get_noise_2d(_world_noise, f32(x) + chunk.p_Position.x * ut.ChunkSizeX, f32(y) + chunk.p_Position.z * ut.ChunkSizeZ)
        }
    }

    for x := 0; x < ut.ChunkSizeX; x += 1 {
        for z := 0; z < ut.ChunkSizeZ; z += 1 {
            generated_x = f32(x)
            generated_y = (_world_height_map[x][z] / 2 + 1.0) * (ut.ChunkSizeY - 32)
            generated_z = f32(z)

            set_vertical_blocks(chunk, int(generated_x), int(generated_z), int(generated_y))
            
            if ut.random_uint(&_world_rng, 75) == 7 && generated_x + ut.MaxStructureX < ut.ChunkSizeX && generated_y + ut.MaxStructureY < ut.ChunkSizeY && generated_z + ut.MaxStructureZ < ut.ChunkSizeZ {
                fillin_world_structure(chunk, &tree_structure.base, i32(generated_x), i32(generated_y) - 1, i32(generated_z))
            }
        }
    }
}

set_vertical_blocks :: proc(chunk: ^co.Chunk, x, z, y_level: int) {
    y := y_level
    if y >= ut.ChunkSizeY {
        y = ut.ChunkSizeY - 1
    }

    for i := 0; i < y; i += 1 {
        if i >= y - 5 {
            co.chunk_add_block(chunk, co.Block_Type.Dirt, m.vec3{f32(x), f32(i), f32(z)})
        } else {
            co.chunk_add_block(chunk, co.Block_Type.Stone, m.vec3{f32(x), f32(i), f32(z)})
        }
    }
}

fillin_world_structure :: proc(chunk: ^co.Chunk, structure: ^s.World_Structure, x, y, z: i32) {
    block: co.Block

    for i := x; i < x + ut.MaxStructureX; i +=1 {
        sx := i - x
        for j := y; j < y + ut.MaxStructureY; j += 1 {
            sy := j - y
            for k := z; k < z + ut.MaxStructureZ; k += 1 {
                sz := k - z

                if i < ut.ChunkSizeX && j < ut.ChunkSizeY && k < ut.ChunkSizeZ && sx < ut.MaxStructureX && sy < ut.MaxStructureY && sz < ut.MaxStructureZ {
                    if structure.p_Structure[sx][sy][sz].p_BlockType != co.Block_Type.Air {
                        block.p_BlockType = structure.p_Structure[sx][sy][sz].p_BlockType
                        block.p_Position = m.vec3{f32(i), f32(j), f32(k)}
                        co.chunk_add_block_nopos(chunk, block)
                    }
                }
            }
        }
    }
}