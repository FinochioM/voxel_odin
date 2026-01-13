package opengl_classes

import gl "vendor:glfw"
import "core:strings"
import "core:time"
import "core:fmt"
import "core:mem"

MAX_FPS : i64 : 65;
PRINT_FPS : bool : true;
FPS_COUNT : i64 = 0;

last_fps_time_sec : f64 = 0.0;
frames : i64 = 0
fps_initialized : bool = false;

display_last_time_sec : f64 = 0.0
display_frames        : i64 = 0
display_initialized   : bool = false

cap_frame_rate :: proc(frame_start_time_sec: f64) {
    target_frame_sec := 1.0 / f64(MAX_FPS)

    now_sec : f64 = gl.GetTime()
    frame_time_sec : f64 = now_sec - frame_start_time_sec
    remaining_sec : f64 = target_frame_sec - frame_time_sec

    if remaining_sec > 0.0 {
        time.sleep(time.Duration(remaining_sec * 1e9))
    }
}

calculate_frame_rate :: proc(window: gl.WindowHandle) {
    frame_start_sec := gl.GetTime()

    if !fps_initialized {
        last_fps_time_sec = frame_start_sec
        fps_initialized = true
    }

    frames += 1

    now_sec := gl.GetTime()
    delta_sec := now_sec - last_fps_time_sec

    if delta_sec >= 1.0 {
        fps := f64(frames) / delta_sec

        title_string_source := fmt.ctprintf(string("Voxel Engine - FPS: %.2f"), fps, false)
        gl.SetWindowTitle(window, title_string_source)

        frames = 0
        last_fps_time_sec = now_sec
    }

    FPS_COUNT += 1
    cap_frame_rate(frame_start_sec)
}

get_fps_count :: proc() -> i64 {
    return FPS_COUNT
}

display_frame_rate :: proc(window: gl.WindowHandle, title: string) {
    if !display_initialized {
        display_last_time_sec = gl.GetTime()
        display_initialized = true
    }

    display_frames += 1

    now_sec := gl.GetTime()
    delta_sec := now_sec - display_last_time_sec

    if delta_sec >= 1.0 {
        fps := f64(display_frames) / delta_sec

        title_c := fmt.ctprintf("%s - FPS: %.2f", title, fps)
        gl.SetWindowTitle(window, title_c)

        display_frames = 0
        display_last_time_sec = now_sec
    }
}