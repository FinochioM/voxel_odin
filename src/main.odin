package main

import app "core/application"

import "vendor:glfw"


main :: proc() {
    using app

    voxel_app := application_init()

    for (!glfw.WindowShouldClose(voxel_app.m_Window)) {
        application_on_update(voxel_app)
    }
}