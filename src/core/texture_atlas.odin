package core

import opcl "../opengl_classes"
import m "core:math/linalg/glsl"

Texture_Atlas :: struct {
    m_TileX, m_TileY: i32,
    m_Atlas: opcl.Texture
}

texture_atlas_init :: proc(atlas_texture: opcl.Texture, tx, ty: i32) -> Texture_Atlas {
    ta : Texture_Atlas

    ta.m_Atlas = atlas_texture
    ta.m_TileX = tx
    ta.m_TileY = ty

    return ta
}

texture_atlas_init_from_file :: proc(atlas_path: string, tx, ty: i32) -> Texture_Atlas {
    ta : Texture_Atlas

    ta.m_Atlas = opcl.texture_init_from_file(atlas_path)
    ta.m_TileX = tx
    ta.m_TileY = ty
    
    return ta
}

texture_atlas_sample :: proc(ta: ^Texture_Atlas, start_coords, end_coords: m.vec2) -> opcl.Texture {
    width, height, x2, y2, x1, y1 : f32

    width = f32(ta.m_TileX) * (end_coords.x - start_coords.x)
    height = f32(ta.m_TileY) * (end_coords.y - start_coords.y)

    texture_coordinates : [8]f32

    x1 = start_coords.x * f32(ta.m_TileX)
    y1 = start_coords.y * f32(ta.m_TileY)
    x2 = end_coords.x * f32(ta.m_TileX)
    y2 = end_coords.y * f32(ta.m_TileY)

    x1 = x1 / f32(opcl.get_width(&ta.m_Atlas))
    y1 = y1 / f32(opcl.get_height(&ta.m_Atlas))
    x2 = x2 / f32(opcl.get_width(&ta.m_Atlas))
    y2 = y2 / f32(opcl.get_height(&ta.m_Atlas))

    texture_coordinates[0] = x2
    texture_coordinates[1] = y2
    texture_coordinates[2] = x2
    texture_coordinates[3] = y1
    texture_coordinates[4] = x1
    texture_coordinates[5] = y1
    texture_coordinates[6] = x1
    texture_coordinates[7] = y2

    tex := opcl.texture_init()

    tex = ta.m_Atlas

    opcl.create_texture_int(&tex, tex.texture, texture_coordinates, i32(width), i32(height), false)

    return tex
}

texture_atlas_sample_custom :: proc(ta: ^Texture_Atlas, start_coords, end_coords: m.vec2) -> opcl.Texture {
    width, height, x2, y2, x1, y1 : f32

    width = end_coords.x - start_coords.x
    height = end_coords.y - start_coords.y

    texture_coordinates : [8]f32

    x1 = start_coords.x
    y1 = start_coords.y
    x2 = end_coords.x
    y2 = end_coords.y

    x1 = x1 / f32(opcl.get_width(&ta.m_Atlas))
    y1 = y1 / f32(opcl.get_height(&ta.m_Atlas))
    x2 = x2 / f32(opcl.get_width(&ta.m_Atlas))
    y2 = y2 / f32(opcl.get_height(&ta.m_Atlas))

    texture_coordinates[0] = x2
    texture_coordinates[1] = y2
    texture_coordinates[2] = x2
    texture_coordinates[3] = y1
    texture_coordinates[4] = x1
    texture_coordinates[5] = y1
    texture_coordinates[6] = x1
    texture_coordinates[7] = y2

    tex := opcl.texture_init()

    tex = ta.m_Atlas

    opcl.create_texture_int(&tex, tex.texture, texture_coordinates, i32(width), i32(height), false)

    return tex
}