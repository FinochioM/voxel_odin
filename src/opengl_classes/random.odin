package opengl_classes

import "core:math/rand"
import "core:time"

random_initialized : bool = false

random_init :: proc() {
    if random_initialized {
        return
    }

    t := time.now()
    seed := u64(time.time_to_unix_nano(t))
    rand.reset(seed)

    random_initialized = true
}

random_float :: proc() -> f32 {
    if !random_initialized {
        random_init()
    }

    return rand.float32()
}