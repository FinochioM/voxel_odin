package renderer

import opcl "../../opengl_classes"
import ut "../utils"
import co "../../core"

import op "vendor:OpenGL"

import m "core:math/linalg/glsl"

Renderer :: struct {
    m_VBO: opcl.VertexBuffer,
    m_VAO: opcl.VertexArray,
    m_DefaultShader: opcl.Shader,
    m_BlockAtlas: opcl.Texture,
}

renderer_init :: proc() -> Renderer {
    r : Renderer
    using r, opcl, op

    m_DefaultShader = shader_init_from_file("src/shaders/vertex.glsl", "src/shaders/fragment.glsl")
    compile_shaders(&m_DefaultShader)
    
    m_BlockAtlas = texture_init_from_file("src/resources/block_atlas.png")

    return r
}

renderer_render_chunk :: proc(r: ^Renderer, chunk: ^co.Chunk, camera: ^co.Camera) {
    using opcl, op, m, co

    shader_use(&r.m_DefaultShader)

    texture_bind(&r.m_BlockAtlas, 0)
    set_integer(&r.m_DefaultShader, "u_Texture", 0, false)
    set_matrix4(&r.m_DefaultShader, "u_Model", mat4(1.0), false)
    set_matrix4(&r.m_DefaultShader, "u_ViewProjection", get_view_projection(camera), false)

    cm := get_chunk_mesh(chunk)
    vertex_array_bind(&cm.p_VAO)

    DrawArrays(TRIANGLES, 0, i32(len(cm.p_Vertices) * 6))

    vertex_array_unbind(&cm.p_VAO)
}