package opengl_classes

import op "vendor:OpenGL"

VertexBuffer :: struct {
    buffer_id : u32,
    type : u32,
}

vertex_buffer_init :: proc(type: u32) -> VertexBuffer {
    v : VertexBuffer

    v.buffer_id = 0
    v.type = type

    op.GenBuffers(1, &v.buffer_id)

    //vertex_buffer_bind(&v)

    return v
}

vertex_buffer_destroy :: proc(v: ^VertexBuffer) {
    op.DeleteBuffers(1, &v.buffer_id)
    vertex_buffer_unbind(v)
}

vertex_buffer_buffer_data :: proc(v: ^VertexBuffer, size: int, data: rawptr, usage: u32) {
    vertex_buffer_bind(v)

    op.BufferData(v.type, size, data, usage)
}

vertex_buffer_bind :: proc(v: ^VertexBuffer) {
    op.BindBuffer(v.type, v.buffer_id)
}

vertex_buffer_unbind :: proc(v: ^VertexBuffer) {
    op.BindBuffer(v.type, 0)
}

vertex_attrib_pointer :: proc(v: ^VertexBuffer, index: u32, size: i32, type: u32, normalized: bool, stride: i32, pointer: uintptr) {
    vertex_buffer_bind(v)

    op.VertexAttribPointer(index, size, type, normalized, stride, pointer)
    op.EnableVertexAttribArray(index)
}