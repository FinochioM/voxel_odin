package world

import co "../../core"
import ut "../utils"
import re "../renderer"
import pl "../player"
import ev "../events"

import m "core:math/linalg/glsl"

import "vendor:glfw"

Chunk_Coord :: struct {
    x, y, z: ut.CoordType
}

Chunk_Pair :: struct {
    x, y: i32
}

World :: struct {
    p_Player: pl.Player,
    m_Renderer: re.Renderer,
    m_Chunks: map[Chunk_Coord]co.Chunk,
    m_ChunkCount: i32,
    m_WorldChunks: [16][16]co.Chunk,
}

world_init :: proc(w: ^World) {
    w.p_Player = pl.player_init()
    w.m_Renderer = re.renderer_init()
    
    ut.log_to_console("initialized world gen")
    
    for i := 0; i < 16; i += 1 {
        for j := 0; j < 16; j+= 1 {
            co.chunk_init(&w.m_WorldChunks[i][j])
            generate_chunk(&w.m_WorldChunks[i][j])
        }
    }

    ut.log_to_console("ended world gen")
    ut.log_to_console("initialized chunk mesh construction")

    for i := 0; i < 16; i += 1 {
        for j := 0; j < 16; j += 1 {
            co.chunk_construct(&w.m_WorldChunks[i][j], m.vec3{f32(i), 1, f32(j)})
        }
    }

    ut.log_to_console("ended chunk mesh construction")
}

world_destroy :: proc() {}

world_on_update :: proc(w: ^World, window: glfw.WindowHandle) {
    pl.player_on_update(&w.p_Player)

    camera_speed :: 0.25

    if glfw.GetKey(window, glfw.KEY_ESCAPE) == glfw.PRESS {
        glfw.SetWindowShouldClose(window, true)
    }

    if glfw.GetKey(window, glfw.KEY_W) == glfw.PRESS {
        co.camera_move(&w.p_Player.p_Camera, co.Move_Direction.Front, camera_speed)
    }

    if glfw.GetKey(window, glfw.KEY_S) == glfw.PRESS {
        co.camera_move(&w.p_Player.p_Camera, co.Move_Direction.Back, camera_speed)
    }

    if glfw.GetKey(window, glfw.KEY_A) == glfw.PRESS {
        co.camera_move(&w.p_Player.p_Camera, co.Move_Direction.Left, camera_speed)
    }

    if glfw.GetKey(window, glfw.KEY_D) == glfw.PRESS {
        co.camera_move(&w.p_Player.p_Camera, co.Move_Direction.Right, camera_speed)
    }

    if glfw.GetKey(window, glfw.KEY_SPACE) == glfw.PRESS {
        co.camera_move(&w.p_Player.p_Camera, co.Move_Direction.Up, camera_speed)
    }

    if glfw.GetKey(window, glfw.KEY_LEFT_SHIFT) == glfw.PRESS {
        co.camera_move(&w.p_Player.p_Camera, co.Move_Direction.Down, camera_speed)
    }
}

world_render_world :: proc(w: ^World) {
    render_distance :: 4

    chunks : [dynamic]Chunk_Pair

    player_chunk_x := 0
    player_chunk_y := 0
    player_chunk_z := 0

    def_pos : f32 = 1

    if w.p_Player.p_Position.x < def_pos {
        player_chunk_x = 0
    } else {
        player_chunk_x = int(m.ceil(w.p_Player.p_Position.x / ut.ChunkSizeX))
    }

    if w.p_Player.p_Position.y < def_pos {
        player_chunk_y = 0_
    } else {
        player_chunk_y = int(m.ceil(w.p_Player.p_Position.y / ut.ChunkSizeY))
    }

    if w.p_Player.p_Position.z < def_pos {
        player_chunk_z = 0
    } else {
        player_chunk_z = int(m.ceil(w.p_Player.p_Position.z / ut.ChunkSizeZ))
    }

    for i := 0; i < 4; i += 1 {
        for j := 0; j < 4; j += 1 {
            re.renderer_render_chunk(&w.m_Renderer, &w.m_WorldChunks[i][j], &w.p_Player.p_Camera)
        }
    }
}

world_on_event :: proc(w: ^World, e: ev.Event) {
    if e.type == ev.Event_Types.MouseMove {
        co.camera_update_on_movement(&w.p_Player.p_Camera, e.mx, e.my)
    }
}