package world

import op "vendor:OpenGL"

import co "../../core"
import opcl "../../opengl_classes"
import ut "../utils"

Skybox :: struct {
    m_VBO: opcl.VertexBuffer,
    m_VAO: opcl.VertexArray,
    m_SkyboxShader: opcl.Shader,
    m_CubeMap: opcl.Cube_Texture_Map,
}

skybox_init :: proc() -> Skybox {
    sky: Skybox

    sky.m_VAO = opcl.vertex_array_init()
    sky.m_VBO = opcl.vertex_buffer_init(op.ARRAY_BUFFER)

    skybox_vertices := [108]f32 {
        -1.0,  1.0, -1.0,
        -1.0, -1.0, -1.0,
        1.0, -1.0, -1.0,
        1.0, -1.0, -1.0,
        1.0,  1.0, -1.0,
        -1.0,  1.0, -1.0,

        -1.0, -1.0,  1.0,
        -1.0, -1.0, -1.0,
        -1.0,  1.0, -1.0,
        -1.0,  1.0, -1.0,
        -1.0,  1.0,  1.0,
        -1.0, -1.0,  1.0,

        1.0, -1.0, -1.0,
        1.0, -1.0,  1.0,
        1.0,  1.0,  1.0,
        1.0,  1.0,  1.0,
        1.0,  1.0, -1.0,
        1.0, -1.0, -1.0,

        -1.0, -1.0,  1.0,
        -1.0,  1.0,  1.0,
        1.0,  1.0,  1.0,
        1.0,  1.0,  1.0,
        1.0, -1.0,  1.0,
        -1.0, -1.0,  1.0,

        -1.0,  1.0, -1.0,
        1.0,  1.0, -1.0,
        1.0,  1.0,  1.0,
        1.0,  1.0,  1.0,
        -1.0,  1.0,  1.0,
        -1.0,  1.0, -1.0,

        -1.0, -1.0, -1.0,
        -1.0, -1.0,  1.0,
        1.0, -1.0, -1.0,
        1.0, -1.0, -1.0,
        -1.0, -1.0,  1.0,
        1.0, -1.0,  1.0
    }
    
    sky.m_CubeMap = opcl.cube_texture_map_init()
    faces := make([dynamic]string, 0, 6)

    append(&faces, 
	    "src/resources/skybox/right.jpg",
	    "src/resources/skybox/left.jpg",
	    "src/resources/skybox/top.jpg",
	    "src/resources/skybox/bottom.jpg",
	    "src/resources/skybox/front.jpg",
	    "src/resources/skybox/back.jpg"
    )

    opcl.create_cube_texture_map(&sky.m_CubeMap, faces)
    
    sky.m_SkyboxShader = opcl.shader_init_from_file("src/shaders/skybox_vertex.glsl", "src/shaders/skybox_fragment.glsl")
    opcl.compile_shaders(&sky.m_SkyboxShader)

    opcl.vertex_array_bind(&sky.m_VAO)
    opcl.vertex_buffer_buffer_data(&sky.m_VBO, size_of(skybox_vertices), rawptr(&skybox_vertices[0]), op.STATIC_DRAW)
    opcl.vertex_attrib_pointer(&sky.m_VBO, 0, 3, op.FLOAT, op.FALSE, 3 * size_of(f32), 0)
    opcl.vertex_array_unbind(&sky.m_VAO)

    return sky
}

skybox_render :: proc(sky: ^Skybox, camera: ^co.Camera) {
    op.DepthMask(op.FALSE)
    
    opcl.shader_use(&sky.m_SkyboxShader)
    opcl.set_matrix4(&sky.m_SkyboxShader, "u_ViewProjection", co.get_skybox_view_projection(camera), false)
    opcl.set_integer(&sky.m_SkyboxShader, "u_Skybox", 0, false)

    opcl.vertex_array_bind(&sky.m_VAO)
    op.ActiveTexture(op.TEXTURE0)

    op.BindTexture(op.TEXTURE_CUBE_MAP, opcl.cube_texture_map_get_id(&sky.m_CubeMap))
    op.DrawArrays(op.TRIANGLES, 0, 36)
    op.DepthMask(op.TRUE)

    opcl.vertex_array_unbind(&sky.m_VAO)
}
