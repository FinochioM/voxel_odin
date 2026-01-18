package world

import co "../../core"
import ut "../utils"
import re "../renderer"
import pl "../player"

import m "core:math/linalg/glsl"

Chunk_Coord :: struct {
    x, y, z: ut.CoordType
}

World :: struct {
    p_Player: ^pl.Player,
    m_Renderer: re.Renderer,
    m_Chunks: map[Chunk_Coord]co.Chunk,
    m_ChunkCount: i32,
}

world_init :: proc() -> World {
    w : World

    return w
}

world_destroy :: proc() {}

world_on_update :: proc(w: ^World) {
    pl.player_on_update(w.p_Player)
}

world_render_world :: proc() {
    
}

world_on_event :: proc() {

}