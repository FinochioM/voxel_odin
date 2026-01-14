package opengl_classes

import "core:path/filepath"
import op "vendor:OpenGL"
import "core:strings"
import "core:mem"
import "core:fmt"
import "core:os"
import m "core:math/linalg/glsl"

Shader :: struct {
    program : u32,
    compiled : bool,
    vertex_src : string,
    fragment_src : string,
    vertex_path : string,
    fragment_path: string,
    uniform_cache: map[string]i32,
}

get_file_name :: proc(path: string) -> string {
    return filepath.base(path)
}

shader_init_from_string :: proc(vertex_src: string, fragment_src: string) -> Shader {
    sh : Shader
    sh.vertex_path = "PASSED_VIA_DATA"
    sh.fragment_path = "PASSED_VIA_DATA"
    sh.uniform_cache = make(map[string]i32)

    sh.vertex_src   = strings.clone(vertex_src, context.allocator)
    sh.fragment_src = strings.clone(fragment_src, context.allocator)

    return sh
}

shader_init_from_file :: proc(vertex_path: string, fragment_path: string) -> Shader{
    sh : Shader
    sh.vertex_path = vertex_path
    sh.fragment_path = fragment_path
    sh.uniform_cache = make(map[string]i32)

    v_bytes, v_ok := os.read_entire_file(vertex_path)
    if !v_ok {
        fmt.printf("ERROR: Failed to read vertex shader file: %s\n", vertex_path)
        return sh
    }
    defer delete(v_bytes)

    f_bytes, f_ok := os.read_entire_file(fragment_path)
    if !f_ok {
        fmt.printf("ERROR: Failed to read fragment shader file: %s\n", fragment_path)
        return sh
    }
    defer delete(f_bytes)

    sh.vertex_src = strings.clone(string(v_bytes), context.allocator)
    sh.fragment_src = strings.clone(string(f_bytes), context.allocator)

    return sh
}

shader_destroy :: proc(sh: ^Shader) {
    op.UseProgram(0)

    if sh.program != 0 {
        op.DeleteProgram(sh.program)
        sh.program = 0
    }

    if len(sh.vertex_src) != 0 {
        mem.delete(sh.vertex_src, context.allocator)
        sh.vertex_src = ""
    }

    if len(sh.fragment_src) != 0 {
        mem.delete(sh.fragment_src, context.allocator)
        sh.fragment_src = ""
    }

    delete(sh.uniform_cache)
    sh.uniform_cache = nil

    sh.compiled = false
}

compile_shaders :: proc(sh: ^Shader) {
    vs : u32;
    fs : u32;
    succesful : i32;
    gl_info_log : [512]u8

    vs = op.CreateShader(op.VERTEX_SHADER)
    fs = op.CreateShader(op.FRAGMENT_SHADER)

    vs_char := strings.clone_to_cstring(sh.vertex_src, context.allocator)
    fs_char := strings.clone_to_cstring(sh.fragment_src, context.allocator)

    defer mem.delete(vs_char, context.allocator)
    defer mem.delete(fs_char, context.allocator)

    op.ShaderSource(vs, 1, &vs_char, nil)
    op.ShaderSource(fs, 1, &fs_char, nil)

    op.CompileShader(vs)
    op.GetShaderiv(vs, op.COMPILE_STATUS, &succesful)
    if succesful == 0 {
        op.GetShaderInfoLog(vs, 512, nil, &gl_info_log[0])
        fmt.printf("\nCOMPILATION ERROR IN VERTEX SHADER :: %s\nINFO LOG :: %s", sh.vertex_path, &gl_info_log[0])
    }

    op.CompileShader(fs)
    op.GetShaderiv(fs, op.COMPILE_STATUS, &succesful)
    if succesful == 0 {
        op.GetShaderInfoLog(fs, 512, nil, &gl_info_log[0])
        fmt.printf("\nCOMPILATION ERROR IN FRAGMENT SHADER :: %s\nINFO LOG :: %s", sh.fragment_path, &gl_info_log[0])
    }

    // prever recall
    if sh.program != 0 {
        op.DeleteProgram(sh.program)
        sh.program = 0
    }

    sh.program = op.CreateProgram()
    op.AttachShader(sh.program, vs)
    op.AttachShader(sh.program, fs)
    op.LinkProgram(sh.program)

    op.GetProgramiv(sh.program, op.LINK_STATUS, &succesful)
    if succesful == 0 {
        op.GetProgramInfoLog(sh.program, 512, nil, &gl_info_log[0])
        fmt.printf("\nERROR :: SHADER LINKING FAILED :: %s", &gl_info_log[0])
    }

    sh.compiled = true
    op.DeleteShader(vs)
    op.DeleteShader(fs)
}

get_program_id :: proc(sh: ^Shader) -> u32 {
    return sh.program
}

shader_use :: proc(sh: ^Shader) {
    if sh.compiled == false {
        compile_shaders(sh)
    }

    op.UseProgram(sh.program)
}

// set
set_float :: proc(sh: ^Shader, name: string, value: f32, useShader: bool) {
    if (useShader) {
        shader_use(sh)
    }

    op.Uniform1f(get_uniform_location(sh, name), value)
}

set_integer :: proc(sh: ^Shader, name: string, value: i32, useShader: bool) {
    if useShader {
        shader_use(sh)
    }

    op.Uniform1i(get_uniform_location(sh, name), value)
}

set_integer_array :: proc(sh: ^Shader, name: string, value: ^i32, count: i32, useShader: bool) {
    if useShader {
        shader_use(sh)
    }

    op.Uniform1iv(get_uniform_location(sh, name), count, value)
}

set_vector2f :: proc(sh: ^Shader, name: string, x, y: f32, useShader: bool) {
    if useShader {
        shader_use(sh)
    }

    op.Uniform2f(get_uniform_location(sh, name), x, y)
}

set_vector2fv :: proc(sh: ^Shader, name: string, value: m.vec2, useShader: bool) {
    if useShader {
        shader_use(sh)
    }

    op.Uniform2f(get_uniform_location(sh, name), value.x, value.y)
}

set_vector3f :: proc(sh: ^Shader, name: string, x, y, z: f32, useShader: bool) {
    if useShader {
        shader_use(sh)
    }

    op.Uniform3f(get_uniform_location(sh, name), x, y, z)
}

set_vector3fv :: proc(sh: ^Shader, name: string, value: m.vec3, useShader: bool) {
    if useShader {
        shader_use(sh)
    }

    op.Uniform3f(get_uniform_location(sh, name), value.x, value.y, value.z)
}

set_vector4f :: proc(sh: ^Shader, name: string, x, y, z, w: f32, useShader: bool) {
    if useShader {
        shader_use(sh)
    }

    op.Uniform4f(get_uniform_location(sh, name), x, y, z, w)
}

set_vector4fv :: proc(sh: ^Shader, name: string, value: m.vec4, useShader: bool) {
    if useShader {
        shader_use(sh)
    }

    op.Uniform4f(get_uniform_location(sh, name), value.x, value.y, value.z, value.w)
}

set_matrix4 :: proc(sh: ^Shader, name: string, matt: m.mat4, useShader: bool) {
    if useShader {
        shader_use(sh)
    }

    loc := get_uniform_location(sh, name)

    mat := matt
    op.UniformMatrix4fv(loc, 1, false, cast([^]f32)rawptr(&mat))
}

// get
get_uniform_location :: proc(sh: ^Shader, uniform_name: string) -> i32 {
    if loc, ok := sh.uniform_cache[uniform_name]; ok {
        return loc
    }

    name_c := strings.clone_to_cstring(uniform_name, context.allocator)
    defer mem.delete(name_c, context.allocator)

    loc := op.GetUniformLocation(sh.program, name_c)
    sh.uniform_cache[uniform_name] = loc

    return loc
}