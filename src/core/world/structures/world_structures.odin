package structures

import co "../../../core"
import ut "../../utils"

import m "core:math/linalg/glsl"

World_Structure_Type :: enum {
    Trees,
    Cacti,
    Undefined,
}

World_Structure :: struct {
    p_Structure: [ut.MaxStructureX][ut.MaxStructureY][ut.MaxStructureZ]co.Block,
    p_StructureType: World_Structure_Type,
}

world_structure_init :: proc() -> World_Structure {
    ws: World_Structure
    ws.p_StructureType = .Undefined

    for i := 0; i < ut.MaxStructureX; i += 1 {
        for j := 0; j < ut.MaxStructureY; j += 1 {
            for k := 0; k < ut.MaxStructureZ; k += 1 {
                b: co.Block
                b.p_BlockType = co.Block_Type.Air
                b.p_Position = m.vec3{f32(i), f32(j), f32(k)}

                ws.p_Structure[i][j][k] = b
            }
        }
    }

    return ws
}

world_structure_set_block :: proc(ws: ^World_Structure, x, y, z: f32, type: co.Block_Type) {
    b: co.Block
    b.p_Position = m.vec3{x, y, z}
    b.p_BlockType = type

    ws.p_Structure[i32(x)][i32(y)][i32(z)] = b
}