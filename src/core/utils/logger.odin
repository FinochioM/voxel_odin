package utils

import "core:fmt"

log_to_console :: proc(text: string) {
    fmt.printf("LOGGER: %s\n", text)
}

log_to_console_fmt :: proc(fmt_string: string, args: ..any) {
    fmt.printf("LOGGER: ")
    fmt.printf(fmt_string, args)
    fmt.printf("\n")
}