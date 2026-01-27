package opengl_classes

import "core:strings"
import "core:mem"
import "core:fmt"
import op "vendor:OpenGL"
import st "vendor:stb/image"

Texture :: struct {
    texture : u32,
    tex_coords : [8]f32,
    cleanup : bool,
    width, height, bpp: i32,
    type, int_format : u32,
    delete_texture : bool,
    path : string,
}

texture_init :: proc() -> Texture {
    t : Texture

    t.tex_coords = {1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0}
    t.cleanup = true
    t.width = 0
    t.height = 0
    t.texture = 0
    t.type = op.TEXTURE_2D
    t.int_format = op.RGBA
    t.bpp = 0
    t.delete_texture = true
    t.path = ""

    return t
}

texture_init_from_file :: proc(path: string, 
    int_format: u32 = op.RGBA, 
    type: u32 = op.TEXTURE_2D, 
    min_filter: i32 = op.NEAREST, 
    mag_filter: i32 = op.NEAREST, 
    texwrap_s: i32 = op.REPEAT, 
    texwrap_t: i32 = op.REPEAT, 
    tex_coords: [8]f32 = {1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0}, 
    cleanup: bool = true
) -> Texture {
    st.set_flip_vertically_on_load(1) // change later

    t := texture_init()
    create_texture(&t, path, int_format, type, min_filter, mag_filter, texwrap_s, texwrap_t, tex_coords, cleanup)

    return t
}

texture_destroy :: proc(t: ^Texture) {
    if t.delete_texture == true && t.texture != 0 {
        op.DeleteTextures(1, &t.texture)
        t.texture = 0
    } else {
        // do nothing
    }
}

create_texture :: proc(t: ^Texture, path: string, int_format: u32, type: u32, min_filter: i32, mag_filter: i32, texwrap_s: i32, texwrap_t: i32, tex_coords: [8]f32, cleanup: bool) {
    st.set_flip_vertically_on_load(0) // change later

    if t.texture != 0 && t.delete_texture {
        op.DeleteTextures(1, &t.texture)
        t.texture = 0
    }

    t.delete_texture = true
    t.tex_coords = tex_coords
    t.cleanup = cleanup
    t.type = type
    t.path = path
    t.int_format = int_format

    op.GenTextures(1, &t.texture)
    op.BindTexture(type, t.texture)

    op.TexParameteri(type, op.TEXTURE_WRAP_S, texwrap_s)
    op.TexParameteri(type, op.TEXTURE_WRAP_T, texwrap_t)
    op.TexParameteri(type, op.TEXTURE_MAG_FILTER, mag_filter)
    op.TexParameteri(type, op.TEXTURE_MIN_FILTER, min_filter)

    path_c := strings.clone_to_cstring(path, context.allocator)
    defer mem.delete(path_c, context.allocator)

    image := st.load(path_c, &t.width, &t.height, &t.bpp, 4)
    if image == nil {
        fmt.printf("STB ERROR :: Could not load image\n")
        return
    }
    defer if cleanup {st.image_free(image)}

    op.TexImage2D(type, 0, i32(int_format), t.width, t.height, 0, int_format, op.UNSIGNED_BYTE, image)
    op.GenerateMipmap(type)
}

create_texture_int :: proc(t: ^Texture, id: u32, tex_coords: [8]f32, w, h: i32, delete_texture: bool) {
    t.texture = id
    t.tex_coords = tex_coords
    t.width = w
    t.height = h
    t.delete_texture = delete_texture
}

get_width :: proc(t: ^Texture) -> i32 {
    return t.width
}

get_height :: proc(t: ^Texture) -> i32 {
    return t.height
}

texture_bind :: proc(t: ^Texture, slot: i32 = 0) {
    op.ActiveTexture(op.TEXTURE0 + u32(slot))
    op.BindTexture(t.type, t.texture)
}

texture_unbind :: proc(t: ^Texture) {
    op.BindTexture(t.type, 0)
}

get_texture_id :: proc(t: ^Texture) -> u32 {
    return t.texture
}

get_texture_path :: proc(t: ^Texture) -> string {
    return t.path
}

get_texture_coords :: proc(t: ^Texture) -> [8]f32 {
    return t.tex_coords
}
