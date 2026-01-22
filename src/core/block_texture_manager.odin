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
cobblestone_block_texture: [8]f32
leaf_block_texture: [8]f32
sand_block_texture: [8]f32
stone_block_texture: [8]f32
wood_block_texture: [2][8]f32

arrays_initialized := false

get_block_texture :: proc(block_type: Block_Type, face_type: Block_Face_Type) -> [8]f32 {
    if arrays_initialized == false {
        arrays_initialized = true

        block_texture_atlas = texture_atlas_init_from_file("src/resources/block_atlas.png", 32, 32)

        dirt_block_texture[0] = texture_atlas_sample(&block_texture_atlas, m.vec2{0,0}, m.vec2{1,1})
        dirt_block_texture[1] = texture_atlas_sample(&block_texture_atlas, m.vec2{1, 1}, m.vec2{2, 2})
        dirt_block_texture[2] = texture_atlas_sample(&block_texture_atlas, m.vec2{3, 3}, m.vec2{2, 2})
        dirt_block_texture[3] = texture_atlas_sample(&block_texture_atlas, m.vec2{3, 3}, m.vec2{4, 4})

        stone_block_texture = texture_atlas_sample(&block_texture_atlas, m.vec2{4, 4}, m.vec2{5, 5})
        cobblestone_block_texture = texture_atlas_sample(&block_texture_atlas, m.vec2{5,5}, m.vec2{6,6})
        wood_block_texture[0] = texture_atlas_sample(&block_texture_atlas, m.vec2{6, 6}, m.vec2{7, 7})
        wood_block_texture[1] = texture_atlas_sample(&block_texture_atlas, m.vec2{7, 7}, m.vec2{8, 8})
        leaf_block_texture = texture_atlas_sample(&block_texture_atlas, m.vec2{8, 8}, m.vec2{9, 9})
        sand_block_texture = texture_atlas_sample(&block_texture_atlas, m.vec2{9, 9}, m.vec2{10, 10})
    }

    #partial switch block_type {
        case .Dirt: {
            #partial switch face_type {
                case .top:
                    return dirt_block_texture[0]
                case .bottom:
                    return dirt_block_texture[1]
                case .left:
                    return dirt_block_texture[2]
                case .right:
                    return dirt_block_texture[2]
                case .front:
                    return dirt_block_texture[3]
                case .backward:
                    return dirt_block_texture[3]
                case:
                    return dirt_block_texture[1]
            }
            break
        }
        case .Stone: {
            return stone_block_texture
        }
        case .Wood: {
            return wood_block_texture[0]
        }
        case .Leaf: {
            return leaf_block_texture
        }
    }

    return wood_block_texture[0]
}