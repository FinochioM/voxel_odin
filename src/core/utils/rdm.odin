package utils

import "core:math/rand"

Random :: struct {
    state: rand.Default_Random_State,
}

random_init :: proc(seed: u64) -> Random {
    r: Random
    r.state = rand.create(seed)
    return r
}

random_float :: proc(r: ^Random) -> f32 {
    gen := rand.default_random_generator(&r.state)
    v := rand.uint32(gen)

    // 4294967295 = 2^32 - 1
    return f32(f64(v) / 4294967295.0)
}

random_int :: proc(r: ^Random, limit: int) -> int {
    if limit <= 0 {
        return 0
    }

    gen := rand.default_random_generator(&r.state)
    v := rand.uint32(gen)

    return int(v % u32(limit))
}

random_uint :: proc(r: ^Random, limit: u32) -> u32 {
    if limit <= 0 {
        return 0
    }

    gen := rand.default_random_generator(&r.state)
    v := rand.uint32(gen)

    return u32(v % u32(limit))
}
