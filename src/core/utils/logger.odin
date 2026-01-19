package utils

import "core:fmt"

log_to_console :: proc(text: string) {
    fmt.printf("LOGGER: %s\n", text)
}