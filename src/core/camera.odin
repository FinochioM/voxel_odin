package core

import m "core:math/linalg/glsl"

Camera :: struct {
    m_Rotation : f32,
    m_Fov : f32,
    m_Aspect : f32,
    m_zNear : f32,
    m_zFar : f32,
    m_Position : m.vec3,
    m_Front : m.vec3,
    m_Up : m.vec3,
    m_ViewMatrix : m.mat4,
    m_ProjectionMatrix : m.mat4,
    m_ViewProjectionMatrix : m.mat4,
}

camera_init :: proc(fov, aspect, zNear, zFar: f32) -> Camera {
    c : Camera
    using c, m

    m_Fov = fov
    m_Aspect = aspect
    m_zNear = zNear
    m_zFar = zFar

    m_Rotation = 0.0
    m_Position = vec3{0.0, 0.0, 0.0}
    m_Front = vec3{0.0, 0.0, -1.0}
    m_Up = vec3{0.0, 1.0, 0.0}

    m_ViewMatrix = mat4LookAt(m_Position, m_Front + m_Position, m_Up)
    m_ProjectionMatrix = mat4Perspective(fov, aspect, zNear, zFar)
    m_ViewProjectionMatrix = m_ProjectionMatrix * m_ViewMatrix
    return c
}

camera_destroy :: proc() {
    // none
}

camera_set_position :: proc(c: ^Camera, position: m.vec3) {
    c.m_Position = position

    camera_recalculate_view_matrix(c)
}

camera_set_rotation :: proc(c: ^Camera, angle: f32) {
    c.m_Rotation = angle

    camera_recalculate_view_matrix(c)
}

camera_set_fov :: proc(c: ^Camera, fov: f32) {
    c.m_Fov = fov

    camera_recalculate_projection_matrix(c)
}

camera_set_aspect :: proc(c: ^Camera, aspect: f32) {
    c.m_Aspect = aspect

    camera_recalculate_projection_matrix(c)
}

camera_set_near_and_far_plane :: proc(c: ^Camera, zNear, zFar: f32) {
    c.m_zNear = zNear
    c.m_zFar = zFar

    camera_recalculate_projection_matrix(c)
}

camera_set_perspective_matrix :: proc(c: ^Camera, fov, aspect_ratio, zNear, zFar: f32) {
    c.m_Fov = fov
    c.m_Aspect = aspect_ratio
    c.m_zNear = zNear
    c.m_zFar = zFar

    camera_recalculate_projection_matrix(c)
}

camera_recalculate_view_matrix :: proc(c: ^Camera) {
    using m

    c.m_ViewMatrix = mat4LookAt(c.m_Position, c.m_Front + c.m_Position, c.m_Up + c.m_Position)
    c.m_ViewMatrix = mat4Rotate(vec3{1.0, 0.5, 0.5}, c.m_Rotation)
}

camera_recalculate_projection_matrix :: proc(c: ^Camera) {
    using m

    c.m_ProjectionMatrix = mat4Perspective(c.m_Fov, c.m_Aspect, c.m_zNear, c.m_zFar)
}

// get
get_position :: proc(c: ^Camera) -> m.vec3 {
    return c.m_Position
}

get_fov :: proc(c: ^Camera) -> f32 {
    return c.m_Fov
}

get_rotation :: proc(c: ^Camera) -> f32 {
    return c.m_Rotation
}

get_view_projection :: proc(c: ^Camera) -> m.mat4 {
    return c.m_ViewProjectionMatrix
}

get_view_matrix :: proc(c: ^Camera) -> m.mat4 {
    return c.m_ViewMatrix
}