package utils

import "core:math/rand"

Random :: struct {
    state: rand.Default_Random_State,
    gen:   rand.Generator, // runtime.Random_Generator wrapper
}

random_init :: proc(seed: u64) -> Random {
    r: Random
    r.state = rand.create(seed)
    r.gen   = rand.default_random_generator(&r.state)
    return r
}

random_float :: proc(r: ^Random) -> f32 {
    v := rand.uint32(r.gen)

    // 4294967295 = 2^32 - 1
    return f32(f64(v) / 4294967295.0)
}

random_int :: proc(r: ^Random, limit: int) -> int {
    if limit <= 0 {
        return 0
    }
    v := rand.uint32(r.gen)
    return int(v % u32(limit))
}