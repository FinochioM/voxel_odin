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
    m_ChunkCount: i32,
    m_WorldChunks: map[int]map[int]^co.Chunk,
}

world_init :: proc(w: ^World) {
    w.p_Player = pl.player_init()
    w.m_Renderer = re.renderer_init()

    w.m_WorldChunks = make(map[int]map[int]^co.Chunk)

    co.camera_set_position(&w.p_Player.p_Camera, m.vec3{2 * 16, 2 * 16, 2 * 16})
    w.p_Player.p_Position = m.vec3{2 * 16, 10 * 16, 2 * 16}

    ut.log_to_console("initialized world gen")

    for i := 0; i < 4; i += 1 {
        row, ok := w.m_WorldChunks[i]
        if !ok {
            row = make(map[int]^co.Chunk)
            w.m_WorldChunks[i] = row
        }

        for j := 0; j < 4; j+= 1 {
            c := new(co.Chunk)
            co.chunk_init(c)
            c.p_Position = m.vec3{f32(i), 1, f32(j)}
            
            row[j] = c
            generate_chunk(c)
        }

        w.m_WorldChunks[i] = row
    }

    ut.log_to_console("ended world gen")
    ut.log_to_console("initialized chunk mesh construction")

    for i := 0; i < 4; i += 1 {
        for j := 0; j < 4; j += 1 {
            ut.timer_init("mesh construction")
            co.chunk_construct(w.m_WorldChunks[i][j], m.vec3{f32(i), 1, f32(j)})
        }
    }

    ut.log_to_console("ended chunk mesh construction")
}

world_destroy :: proc() {}

world_on_update :: proc(w: ^World, window: glfw.WindowHandle) {
    pl.player_on_update(&w.p_Player)

    camera_speed :: 0.35

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

    player_chunk_x = int(m.floor(w.p_Player.p_Position.x / ut.ChunkSizeX))
    player_chunk_y = int(m.floor(w.p_Player.p_Position.y / ut.ChunkSizeY))
    player_chunk_z = int(m.floor(w.p_Player.p_Position.z / ut.ChunkSizeZ))

    /*
    world_render_chunk_from_map(w, player_chunk_x, player_chunk_z)
    world_render_chunk_from_map(w, player_chunk_x + 1, player_chunk_z)
    world_render_chunk_from_map(w, player_chunk_x, player_chunk_z + 1)

    world_render_chunk_from_map(w, player_chunk_x - 1, player_chunk_z)
    world_render_chunk_from_map(w, player_chunk_x - 1, player_chunk_z + 1)
    world_render_chunk_from_map(w, player_chunk_x, player_chunk_z - 1)
    world_render_chunk_from_map(w, player_chunk_x + 1, player_chunk_z + 1)
    world_render_chunk_from_map(w, player_chunk_x + 1, player_chunk_z - 1)
    world_render_chunk_from_map(w, player_chunk_x - 1, player_chunk_z - 1)
    world_render_chunk_from_map(w, player_chunk_x - 1, player_chunk_z + 1)
    */

    render_distance_x, render_distance_z := 4, 4

    for i := player_chunk_z - render_distance_z; i < player_chunk_z + render_distance_z; i += 1 {
        for j := player_chunk_x - render_distance_x; j < player_chunk_x + render_distance_x; j += 1 {
            world_render_chunk_from_map(w, j, i)
        }
    }
}

world_on_event :: proc(w: ^World, e: ev.Event) {
    if e.type == ev.Event_Types.MouseMove {
        co.camera_update_on_movement(&w.p_Player.p_Camera, e.mx, e.my)
    }
}

world_render_chunk_from_map :: proc(w: ^World, cx, cz: int) {
    row, xOk := w.m_WorldChunks[cx]
    if xOk {
        c, zOk := row[cz]
        if zOk && c != nil {
            re.renderer_render_chunk(&w.m_Renderer, c, &w.p_Player.p_Camera)
            return
        }
    }

    if !xOk {
        row = make(map[int]^co.Chunk)
        w.m_WorldChunks[cx] = row
    }

    c := new(co.Chunk)
    co.chunk_init(c)
    
    c.p_Position = m.vec3{f32(cx), 1, f32(cz)}
    generate_chunk(c)
    co.chunk_construct(c, m.vec3{f32(cx), 1, f32(cz)})

    row[cz] = c
    w.m_WorldChunks[cx] = row

    re.renderer_render_chunk(&w.m_Renderer, c, &w.p_Player.p_Camera)
}