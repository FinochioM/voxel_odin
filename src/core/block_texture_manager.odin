package core

import m "core:math/linalg/glsl"

Block_Face_Type :: enum {
    top = 0,
    bottom,
    left,
    right,
    front,
    backward,
}

block_texture_atlas : Texture_Atlas 
dirt_block_texture: [4][8]f32 
stone_block_texture: [8]f32
wood_block_texture: [2][8]f32

arrays_initialized := false

get_block_texture :: proc(block_type: Block_Type, face_type: Block_Face_Type) -> [8]f32 {
    if arrays_initialized == false {
        arrays_initialized = true

        block_texture_atlas = texture_atlas_init_from_file("src/resources/block_atlas.png", 32, 32)

        dirt_block_texture[0] = texture_atlas_sample(&block_texture_atlas, m.vec2{0,0}, m.vec2{1,1})
        dirt_block_texture[1] = texture_atlas_sample(&block_texture_atlas, m.vec2{1, 1}, m.vec2{2, 2})
        dirt_block_texture[2] = texture_atlas_sample(&block_texture_atlas, m.vec2{2, 2}, m.vec2{3, 3})
        dirt_block_texture[3] = texture_atlas_sample(&block_texture_atlas, m.vec2{2, 2}, m.vec2{3, 3})

        stone_block_texture = texture_atlas_sample(&block_texture_atlas, m.vec2{3, 3}, m.vec2{4, 4})
        wood_block_texture[0] = texture_atlas_sample(&block_texture_atlas, m.vec2{3, 3}, m.vec2{4, 4})
        wood_block_texture[1] = texture_atlas_sample(&block_texture_atlas, m.vec2{4, 4}, m.vec2{5, 5})
    }

    #partial switch block_type {
        case .Dirt: {
            #partial switch face_type {
                case .top:
                    return dirt_block_texture[0]
                case .left:
                    return dirt_block_texture[1]
                case .right:
                    return dirt_block_texture[1]
                case:
                    return dirt_block_texture[2]
            }
            break
        }
        case .Stone: {
            return stone_block_texture
        }
    }

    return stone_block_texture
}