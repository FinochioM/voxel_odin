package opengl_classes

import op "vendor:OpenGL"
import stbi "vendor:stb/image"

import "core:strings"
import "core:mem"
import "core:fmt"

Cube_Texture_Map :: struct {
    m_TextureID: u32,
    m_Width, m_Height, m_Channels: i32,
}

cube_texture_map_init :: proc() -> Cube_Texture_Map {
    ctm: Cube_Texture_Map

    return ctm
}

create_cube_texture_map :: proc(ctm: ^Cube_Texture_Map, cube_face_paths: [dynamic]string) {
    image_data: ^u8

    width, height, channels: i32

    op.GenTextures(1, &ctm.m_TextureID)
    op.BindTexture(op.TEXTURE_CUBE_MAP, ctm.m_TextureID)

    m_CubeFacePaths := cube_face_paths

    for i := 0; i < len(cube_face_paths); i += 1 {
        path_c := strings.clone_to_cstring(cube_face_paths[i], context.allocator)
        image_data = stbi.load(path_c, &width, &height, &channels, 3)
        mem.delete(path_c, context.allocator)
    
        if image_data == nil {
            fmt.printf("STB ERROR :: Could not load image\n")
            //stbi.image_free(image_data)
            return
        } else {
            op.TexImage2D(op.TEXTURE_CUBE_MAP_POSITIVE_X + u32(i), 0, op.RGB, width, height, 0, op.RGB, op.UNSIGNED_BYTE, image_data)
            stbi.image_free(image_data)
        }
    }

    op.TexParameteri(op.TEXTURE_CUBE_MAP, op.TEXTURE_MAG_FILTER, op.LINEAR)
    op.TexParameteri(op.TEXTURE_CUBE_MAP, op.TEXTURE_MIN_FILTER, op.LINEAR)
    op.TexParameteri(op.TEXTURE_CUBE_MAP, op.TEXTURE_WRAP_S, op.CLAMP_TO_EDGE)
    op.TexParameteri(op.TEXTURE_CUBE_MAP, op.TEXTURE_WRAP_T, op.CLAMP_TO_EDGE)
    op.TexParameteri(op.TEXTURE_CUBE_MAP, op.TEXTURE_WRAP_R, op.CLAMP_TO_EDGE)
}

cube_texture_map_get_id :: proc(ctm: ^Cube_Texture_Map) -> u32 {
    return ctm.m_TextureID
}
