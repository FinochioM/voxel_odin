package core

import "base:runtime"

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
    
    state: Camera_State,
}

Camera_State :: struct {
    first_move : bool,
    sens, prev_mx, prev_my, yaw, pitch: f32,
}

Move_Direction :: enum {
    Up,
    Down,
    Left,
    Right,
    Front,
    Back,
}

cam_state_init :: proc() -> Camera_State {
    cm : Camera_State

    cm.first_move = false
    cm.sens = 0.2
    cm.prev_mx = 0.0
    cm.prev_my = 0.0
    cm.yaw = 0.0
    cm.pitch = 0.0

    return cm
}

camera_init :: proc(fov, aspect, zNear, zFar: f32) -> Camera {
    context = runtime.default_context()
    c : Camera
    using c, m

    state = cam_state_init()

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

camera_move :: proc(camera: ^Camera, dir: Move_Direction, speed: f32) {
    #partial switch dir {
        case Move_Direction.Front: {
            change_position(camera, get_front(camera) * speed)
            break
        }
        case Move_Direction.Back: {
            change_position(camera, -get_front(camera) * speed)
            break
        }
        case Move_Direction.Left: {
            change_position(camera, -get_right(camera) * speed)
            break
        }
        case Move_Direction.Right: {
            change_position(camera, get_right(camera) * speed)
            break
        }
        case Move_Direction.Up: {
            change_position(camera, get_up(camera) * speed)
            break
        }
        case Move_Direction.Down: {
            change_position(camera, -get_up(camera) * speed)
            break
        }
    }
}

camera_update_on_movement :: proc(c: ^Camera, xpos, ypos: f64) {
    using m

    context = runtime.default_context()

    x := f32(xpos)
    y := f32(ypos)
   
    y = -y

    st := &c.state

    x_diff := x - st.prev_mx
    y_diff := y - st.prev_my

    if st.first_move == false {
        st.first_move = true
        st.prev_mx = x
        st.prev_my = y
    }

    x_diff = x_diff * st.sens
    y_diff = y_diff * st.sens

    st.prev_mx = x
    st.prev_my = y

    st.yaw = st.yaw + x_diff
    st.pitch = st.pitch + y_diff

    if st.pitch > 89.0 {
        st.pitch = 89.0
    }

    if st.pitch < -89.0 {
        st.pitch = -89.0
    }

    front : vec3

    pitch_r := deg_to_rad(st.pitch)
    yaw_r := deg_to_rad(st.yaw)

    front.x = cos(pitch_r) * cos(yaw_r)
    front.y = sin(pitch_r)
    front.z = cos(pitch_r) * sin(yaw_r)

    camera_set_front(c, front)
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

camera_set_front :: proc(c: ^Camera, front: m.vec3) {
    c.m_Front = front

    camera_recalculate_view_matrix(c)
}

camera_recalculate_view_matrix :: proc(c: ^Camera) {
    using m

    c.m_ViewMatrix = mat4LookAt(c.m_Position, c.m_Front + c.m_Position, c.m_Up)

    rot := mat4Rotate(vec3{1.0, 0.5, 0.5}, c.m_Rotation)
    c.m_ViewMatrix = rot * c.m_ViewMatrix

    c.m_ViewProjectionMatrix = c.m_ProjectionMatrix * c.m_ViewMatrix
}

camera_recalculate_projection_matrix :: proc(c: ^Camera) {
    using m

    c.m_ProjectionMatrix = mat4Perspective(c.m_Fov, c.m_Aspect, c.m_zNear, c.m_zFar)

    c.m_ViewProjectionMatrix = c.m_ProjectionMatrix * c.m_ViewMatrix
}

change_position :: proc(c:^Camera, position_increment: m.vec3) {
    c.m_Position = c.m_Position + position_increment

    camera_recalculate_view_matrix(c)
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

get_front :: proc(c: ^Camera) -> m.vec3 {
    return c.m_Front
}

get_up :: proc(c: ^Camera) -> m.vec3 {
    return c.m_Up
}

get_right :: proc(c: ^Camera) -> m.vec3 {
    return m.normalize_vec3(m.cross_vec3(c.m_Front, c.m_Up))
}

get_skybox_view_projection :: proc(c: ^Camera) -> m.mat4 {
    using m

    view := c.m_ViewMatrix

    view_no_translate := mat4(mat3(view))

    return c.m_ProjectionMatrix * view_no_translate
}

// helper
deg_to_rad :: proc(x: f32) -> f32 {
    return x * (m.PI / 180.0)
}
