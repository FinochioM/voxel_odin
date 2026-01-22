package utils

import "core:time"
import "core:fmt"

import log "../utils"

Timer :: struct {
    m_Output: string,
    m_StartTime: time.Time,
    m_EndTime: time.Time,
}

timer_init :: proc(output_text: string) -> Timer {
    t : Timer

    t.m_Output = output_text
    t.m_StartTime = time.now()

    log.log_to_console_fmt("%s | TIMER STARTED", output_text)

    return t
}

timer_destroy :: proc(t: ^Timer) {
    timer_end(t)
}

timer_start :: proc(t: ^Timer) {
    t.m_StartTime = time.now()

    log.log_to_console_fmt("%s | TIMER STARTED", t.m_Output)
}

timer_end :: proc(t: ^Timer) {
    t.m_EndTime = time.now()

    log.log_to_console_fmt("%s | TIMER ENDED | ELAPSED TIME: %d", t.m_Output, time.diff(t.m_StartTime, t.m_EndTime))
}