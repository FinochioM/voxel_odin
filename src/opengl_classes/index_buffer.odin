package opengl_classes

import op "vendor:OpenGL"

IndexBuffer :: struct {
    buffer_id : u32,
    type      : u32
}

index_buffer_init :: proc() -> IndexBuffer {
    ib : IndexBuffer

    ib.type = op.ELEMENT_ARRAY_BUFFER

    op.GenBuffers(1, &ib.buffer_id)
    index_buffer_bind(&ib)

    return ib
}

index_buffer_buffer_data :: proc(ib: ^IndexBuffer, size: int, data: rawptr, usage: u32) {
    index_buffer_bind(ib)

    op.BufferData(ib.type, size, data, usage)
}

index_buffer_destroy :: proc(ib: ^IndexBuffer) {
    op.DeleteBuffers(1, &ib.buffer_id)
    index_buffer_unbind(ib)
}

index_buffer_bind :: proc(ib: ^IndexBuffer) {
    op.BindBuffer(ib.type, ib.buffer_id)
}

index_buffer_unbind :: proc(ib: ^IndexBuffer) {
    op.BindBuffer(ib.type, 0)
    op.BindVertexArray(0)
}