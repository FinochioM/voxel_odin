package world

import co "../../core"
import ut "../utils"

Coord_Pair :: struct {
    x: ut.CoordType,
    z: ut.CoordType
}

World :: struct {
    m_WorldChunks: map[Coord_Pair]co.Chunk
}