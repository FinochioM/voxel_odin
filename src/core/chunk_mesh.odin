package core

import ut "utils"

import m "core:math/linalg/glsl"

import "base:runtime"

Chunk_Mesh :: struct {
    m_TopFace: [4]m.vec4,
    m_BottomFace: [4]m.vec4,
    m_ForwardFace: [4]m.vec4,
    m_BackFace: [4]m.vec4,
    m_LeftFace: [4]m.vec4,
    m_RightFace: [4]m.vec4,
    p_Vertices: [dynamic]ut.Vertex,
}

Face_Type :: enum {
    top,
    bottom,
    left,
    right,
    forward,
    backward,
}

chunk_mesh_init :: proc() -> Chunk_Mesh {
    cm : Chunk_Mesh

    cm.m_ForwardFace[0] = m.vec4{-0.5, -0.5, 0.5, 1.0}
    cm.m_ForwardFace[1] = m.vec4{0.5, -0.5, 0.5, 1.0}
    cm.m_ForwardFace[2] = m.vec4{0.5, 0.5, 0.5, 1.0}
    cm.m_ForwardFace[3] = m.vec4{-0.5, 0.5, 0.5, 1.0}

    cm.m_BackFace[0] = m.vec4{-0.5, -0.5, -0.5, 1.0}
    cm.m_BackFace[1] = m.vec4{0.5, -0.5, -0.5, 1.0}
    cm.m_BackFace[2] = m.vec4{0.5, 0.5, -0.5, 1.0}
    cm.m_BackFace[3] = m.vec4{-0.5, 0.5, -0.5, 1.0}

    cm.m_TopFace[0] = m.vec4{-0.5, 0.5, -0.5, 1.0}
    cm.m_TopFace[1] = m.vec4{0.5, 0.5, -0.5, 1.0}
    cm.m_TopFace[2] = m.vec4{0.5, 0.5, 0.5, 1.0}
    cm.m_TopFace[3] = m.vec4{-0.5, 0.5, 0.5, 1.0}

    cm.m_BottomFace[0] = m.vec4{-0.5, -0.5, -0.5, 1.0}
    cm.m_BottomFace[1] = m.vec4{0.5, -0.5, -0.5, 1.0}
    cm.m_BottomFace[2] = m.vec4{0.5, -0.5, 0.5, 1.0}
    cm.m_BottomFace[3] = m.vec4{-0.5, -0.5, 0.5, 1.0}

    cm.m_LeftFace[0] = m.vec4{-0.5, 0.5, 0.5, 1.0}
    cm.m_LeftFace[1] = m.vec4{-0.5, 0.5, -0.5, 1.0}
    cm.m_LeftFace[2] = m.vec4{-0.5, -0.5, -0.5, 1.0}
    cm.m_LeftFace[3] = m.vec4{-0.5, -0.5, 0.5, 1.0}

    cm.m_RightFace[0] = m.vec4{0.5, 0.5, 0.5, 1.0}
    cm.m_RightFace[1] = m.vec4{0.5, 0.5, -0.5, 1.0}
    cm.m_RightFace[2] = m.vec4{0.5, -0.5, -0.5, 1.0}
    cm.m_RightFace[3] = m.vec4{0.5, -0.5, 0.5, 1.0}

    cm.p_Vertices = make([dynamic]ut.Vertex, 0, 4096) // might vary

    return cm
}

chunk_mesh_add_face :: proc(cm: ^Chunk_Mesh, face_type: Face_Type, position: m.vec3) {
    using ut, cm
    translation := m.mat4Translate(position)

    v1, v2, v3, v4, v5, v6 : Vertex

    #partial switch (face_type) {
        case Face_Type.top: {
            v1.position = (translation * m_TopFace[0]).xyz
            v2.position = (translation * m_TopFace[1]).xyz
            v3.position = (translation * m_TopFace[2]).xyz
            v4.position = (translation * m_TopFace[2]).xyz
            v5.position = (translation * m_TopFace[3]).xyz
            v6.position = (translation * m_TopFace[0]).xyz

            break
        }
        case Face_Type.bottom: {
            v1.position = (translation * m_BottomFace[0]).xyz
            v2.position = (translation * m_BottomFace[1]).xyz
            v3.position = (translation * m_BottomFace[2]).xyz
            v4.position = (translation * m_BottomFace[2]).xyz
            v5.position = (translation * m_BottomFace[3]).xyz
            v6.position = (translation * m_BottomFace[0]).xyz

            break
        }
        case Face_Type.forward: {
            v1.position = (translation * m_ForwardFace[0]).xyz
            v2.position = (translation * m_ForwardFace[1]).xyz
            v3.position = (translation * m_ForwardFace[2]).xyz
            v4.position = (translation * m_ForwardFace[2]).xyz
            v5.position = (translation * m_ForwardFace[3]).xyz
            v6.position = (translation * m_ForwardFace[0]).xyz

            break
        }
        case Face_Type.backward: {
            v1.position = (translation * m_BackFace[0]).xyz
            v2.position = (translation * m_BackFace[1]).xyz
            v3.position = (translation * m_BackFace[2]).xyz
            v4.position = (translation * m_BackFace[2]).xyz
            v5.position = (translation * m_BackFace[3]).xyz
            v6.position = (translation * m_BackFace[0]).xyz

            break
        }
        case Face_Type.left: {
            v1.position = (translation * m_LeftFace[0]).xyz
            v2.position = (translation * m_LeftFace[1]).xyz
            v3.position = (translation * m_LeftFace[2]).xyz
            v4.position = (translation * m_LeftFace[2]).xyz
            v5.position = (translation * m_LeftFace[3]).xyz
            v6.position = (translation * m_LeftFace[0]).xyz

            break
        }
        case Face_Type.right: {
            v1.position = (translation * m_RightFace[0]).xyz
            v2.position = (translation * m_RightFace[1]).xyz
            v3.position = (translation * m_RightFace[2]).xyz
            v4.position = (translation * m_RightFace[2]).xyz
            v5.position = (translation * m_RightFace[3]).xyz
            v6.position = (translation * m_RightFace[0]).xyz

            break
        }
    }

    v1.texture_coords = m.vec2{1.0, 0.0}
    v2.texture_coords = m.vec2{1.0, 1.0}
    v3.texture_coords = m.vec2{0.0, 1.0}
    v4.texture_coords = m.vec2{0.0, 1.0}
    v5.texture_coords = m.vec2{0.0, 0.0}
    v6.texture_coords = m.vec2{1.0, 0.0}

    _, _ = append_elems(&p_Vertices, v1, v2, v3, v4, v5, v6)
}

chunk_mesh_construct_mesh :: proc(cm: ^Chunk_Mesh, chunk: ^[ut.ChunkSizeX][ut.ChunkSizeY][ut.ChunkSizeZ]Block) {
    using cm, ut

    _ = resize_dynamic_array(&p_Vertices, 0)

    for x := 0; x < ChunkSizeX; x += 1 {
        for y := 0; y < ChunkSizeY; y += 1 {
            for z := 0; z < ChunkSizeZ; z += 1 {
                if chunk[x][y][z].p_BlockType != .Air {
                    if x <= 0 {
                        //chunk_mesh_add_face(cm, .right, chunk[x][y][z].p_Position)
                        chunk_mesh_add_face(cm, .left, chunk[x][y][z].p_Position)
                    } else if x >= ChunkSizeX - 1 {
                        chunk_mesh_add_face(cm, .right, chunk[x][y][z].p_Position)
                        //chunk_mesh_add_face(cm, .left, chunk[x][y][z].p_Position)
                    } else {
                        if chunk[x + 1][y][z].p_BlockType == Block_Type.Air {
                            chunk_mesh_add_face(cm, .right, chunk[x][y][z].p_Position)
                        }

                        if chunk[x - 1][y][z].p_BlockType == Block_Type.Air {
                            chunk_mesh_add_face(cm, .left, chunk[x][y][z].p_Position)
                        }
                    }

                    if y <= 0 {
                        chunk_mesh_add_face(cm, .bottom, chunk[x][y][z].p_Position)
                        //chunk_mesh_add_face(cm, .top, chunk[x][y][z].p_Position)                     
                    } else if y >= ChunkSizeY - 1 {
                        //chunk_mesh_add_face(cm, .bottom, chunk[x][y][z].p_Position)
                        chunk_mesh_add_face(cm, .top, chunk[x][y][z].p_Position)   
                    } else {
                        if chunk[x][y - 1][z].p_BlockType == Block_Type.Air {
                            chunk_mesh_add_face(cm, .top, chunk[x][y][z].p_Position)
                        }

                        if chunk[x][y + 1][z].p_BlockType == Block_Type.Air {
                            chunk_mesh_add_face(cm, .bottom, chunk[x][y][z].p_Position)
                        }
                    }
                    
                    if z <= 0 {
                        chunk_mesh_add_face(cm, .backward, chunk[x][y][z].p_Position)
                        //chunk_mesh_add_face(cm, .forward, chunk[x][y][z].p_Position)
                    } else if z >= ChunkSizeZ - 1 {
                        //chunk_mesh_add_face(cm, .backward, chunk[x][y][z].p_Position)
                        chunk_mesh_add_face(cm, .forward, chunk[x][y][z].p_Position)
                    } else {
                        if chunk[x][y][z + 1].p_BlockType == Block_Type.Air {
                            chunk_mesh_add_face(cm, .forward, chunk[x][y][z].p_Position)
                        }

                        if chunk[x][y][z - 1].p_BlockType == Block_Type.Air {
                            chunk_mesh_add_face(cm, .backward, chunk[x][y][z].p_Position)
                        }
                    }
                }
            }
        }
    }
}