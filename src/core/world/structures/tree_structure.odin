package structures

import co "../../../core"

Tree_Structure :: struct {
    base: World_Structure
}

tree_structure_init :: proc() -> Tree_Structure {
    ts: Tree_Structure
    ts.base = world_structure_init()
    ts.base.p_StructureType = .Trees


    world_structure_set_block(&ts.base, 2, 0, 2, co.Block_Type.Wood)
    world_structure_set_block(&ts.base, 2, 1, 2, co.Block_Type.Wood)
    world_structure_set_block(&ts.base, 2, 2, 2, co.Block_Type.Wood)
    world_structure_set_block(&ts.base, 2, 3, 2, co.Block_Type.Leaf)

    for x := 0; x <= 3; x += 1 {
        for z := 0; z <= 3; z += 1 {
            world_structure_set_block(&ts.base, f32(x), 3, f32(z), co.Block_Type.Leaf)
        }
    }

    return ts
}