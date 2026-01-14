package opengl_classes

import op "vendor:OpenGL"

VertexArray :: struct {
    array_id : u32,
    type : u32
}

vertex_array_init :: proc() -> VertexArray {
    v : VertexArray

    v.array_id = 0
    op.GenVertexArrays(1, &v.array_id)
    vertex_array_bind(&v)

    return v
}

vertex_array_destroy :: proc(v: ^VertexArray) {
    if v.array_id != 0 {
        op.DeleteVertexArrays(1, &v.array_id)
        v.array_id = 0
    }
    vertex_array_unbind(v)
}

vertex_array_bind :: proc(v: ^VertexArray) {
    op.BindVertexArray(v.array_id)
}

vertex_array_unbind :: proc(v: ^VertexArray) {
    op.BindVertexArray(0)
}