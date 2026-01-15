package core

import o "../opengl_classes"

import m "core:math/linalg/glsl"

import op "vendor:OpenGL"

Cube :: struct {
    length, height, breadth : f32,
}

Cube_Renderer :: struct {
    m_VBO : o.VertexBuffer,
    m_IBO : o.IndexBuffer,
    m_VAO : o.VertexArray,
    m_DefaultShader : o.Shader
}

cube_renderer_init :: proc() -> Cube_Renderer {
    cb : Cube_Renderer
    using cb, o, op

    m_VAO = vertex_array_init()
    m_VBO = vertex_buffer_init(ARRAY_BUFFER)

    m_DefaultShader = shader_init_from_file("src/shaders/vertex.glsl", "src/shaders/fragment.glsl")
    compile_shaders(&m_DefaultShader)

    vertices := []f32 {
        -0.5, -0.5, -0.5,  0.0, 0.0,
        0.5, -0.5, -0.5,  1.0, 0.0,
        0.5,  0.5, -0.5,  1.0, 1.0,
        0.5,  0.5, -0.5,  1.0, 1.0,
        -0.5,  0.5, -0.5,  0.0, 1.0,
        -0.5, -0.5, -0.5,  0.0, 0.0,

        -0.5, -0.5,  0.5,  0.0, 0.0,
        0.5, -0.5,  0.5,  1.0, 0.0,
        0.5,  0.5,  0.5,  1.0, 1.0,
        0.5,  0.5,  0.5,  1.0, 1.0,
        -0.5,  0.5,  0.5,  0.0, 1.0,
        -0.5, -0.5,  0.5,  0.0, 0.0,

        -0.5,  0.5,  0.5,  1.0, 0.0,
        -0.5,  0.5, -0.5,  1.0, 1.0,
        -0.5, -0.5, -0.5,  0.0, 1.0,
        -0.5, -0.5, -0.5,  0.0, 1.0,
        -0.5, -0.5,  0.5,  0.0, 0.0,
        -0.5,  0.5,  0.5,  1.0, 0.0,

        0.5,  0.5,  0.5,  1.0, 0.0,
        0.5,  0.5, -0.5,  1.0, 1.0,
        0.5, -0.5, -0.5,  0.0, 1.0,
        0.5, -0.5, -0.5,  0.0, 1.0,
        0.5, -0.5,  0.5,  0.0, 0.0,
        0.5,  0.5,  0.5,  1.0, 0.0,

        -0.5, -0.5, -0.5,  0.0, 1.0,
        0.5, -0.5, -0.5,  1.0, 1.0,
        0.5, -0.5,  0.5,  1.0, 0.0,
        0.5, -0.5,  0.5,  1.0, 0.0,
        -0.5, -0.5,  0.5,  0.0, 0.0,
        -0.5, -0.5, -0.5,  0.0, 1.0,

        -0.5,  0.5, -0.5,  0.0, 1.0,
        0.5,  0.5, -0.5,  1.0, 1.0,
        0.5,  0.5,  0.5,  1.0, 0.0,
        0.5,  0.5,  0.5,  1.0, 0.0,
        -0.5,  0.5,  0.5,  0.0, 0.0,
        -0.5,  0.5, -0.5,  0.0, 1.0
    }

    vertex_array_bind(&m_VAO)
    vertex_buffer_buffer_data(&m_VBO, len(vertices)*size_of(f32), rawptr(&vertices[0]), STATIC_DRAW)

    vertex_attrib_pointer(&m_VBO, 0, 3, FLOAT, FALSE, 5 * size_of(f32), 0)
    vertex_attrib_pointer(&m_VBO, 1, 2, FLOAT, FALSE, 5 * size_of(f32), 3 * size_of(f32))

    vertex_array_unbind(&m_VAO)
    return cb
}

cube_renderer_destroy :: proc(cb: ^Cube_Renderer) {
    // none
}

cube_renderer_render :: proc(cb: ^Cube_Renderer, position: m.vec3, texture: ^o.Texture, rotation: f32, projection: m.mat4, view: m.mat4 = m.mat4(1.0), shader: ^o.Shader = nil) {
    using cb, o, op, m

    use_shader := shader

    if use_shader == nil{
        use_shader = &m_DefaultShader
    }

    view := mat4(1.0)
    model := mat4(1.0)

    view = mat4Translate(vec3{0.0, 0.0, -3.0})
    model = mat4Translate(position)
    model = mat4Rotate(vec3{1.0, 0.5, 0.5}, rotation)

    texture_bind(texture, 0)
    shader_use(use_shader)

    set_integer(use_shader, "u_Texture", 0, false)
    set_matrix4(use_shader, "u_Model", model, false)
    set_matrix4(use_shader, "u_View", view, false)
    set_matrix4(use_shader, "u_Projection", projection, false)

    vertex_array_bind(&m_VAO)

    DrawArrays(TRIANGLES, 0, 36)

    vertex_array_unbind(&m_VAO)
}