package renderer

import opcl "../../opengl_classes"
import ut "../utils"
import co "../../core"

import op "vendor:OpenGL"

import m "core:math/linalg/glsl"

Renderer :: struct {
    m_VBO: opcl.VertexBuffer,
    m_VAO: opcl.VertexArray,
    m_DefaultShader: opcl.Shader
}

renderer_init :: proc() -> Renderer {
    r : Renderer
    using r, opcl, op

    m_VAO = vertex_array_init()
    m_VBO = vertex_buffer_init(ARRAY_BUFFER)

    vertex_array_bind(&m_VAO)
    vertex_buffer_bind(&m_VBO)

    vertex_buffer_buffer_data(&m_VBO, (ut.ChunkSizeX * ut.ChunkSizeY * ut.ChunkSizeZ * size_of(ut.Vertex) * 6) + 10, nil, DYNAMIC_DRAW)
    vertex_attrib_pointer(&m_VBO, 0, 3, FLOAT, FALSE, 6 * size_of(f32), 0)
    vertex_attrib_pointer(&m_VBO, 1, 2, FLOAT, FALSE, 6 * size_of(f32), 3 * size_of(f32))
    vertex_attrib_pointer(&m_VBO, 2, 1, FLOAT, FALSE, 6 * size_of(f32), 5 * size_of(f32))
    vertex_array_unbind(&m_VAO)

    m_DefaultShader = shader_init_from_file("src/shaders/vertex.glsl", "src/shaders/fragment.glsl")
    compile_shaders(&m_DefaultShader)

    return r
}

renderer_render_chunk :: proc(r: ^Renderer, chunk: ^co.Chunk, camera: ^co.Camera) {
    using opcl, op, m, co

    shader_use(&r.m_DefaultShader)

    set_matrix4(&r.m_DefaultShader, "u_Model", mat4(1.0), false)
    set_matrix4(&r.m_DefaultShader, "u_View", get_view_projection(camera), false)
    set_matrix4(&r.m_DefaultShader, "u_Projection", mat4(1.0), false)

    vertex_array_bind(&r.m_VAO)

    cm := co.get_chunk_mesh(chunk)
    verts := cm.p_Vertices[:]

    size := len(verts) * size_of(ut.Vertex)
    data := rawptr(&verts[0])

    vertex_buffer_buffer_subdata(&r.m_VBO, 0, size, data)

    DrawArrays(TRIANGLES, 0, i32(len(verts)))

    vertex_array_unbind(&r.m_VAO)
}