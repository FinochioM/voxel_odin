package opengl_classes

import op "vendor:OpenGL"
import "core:fmt"

ERR_CODE : op.GL_Enum;
PRINT_ERROR := "UNKNOWN ERROR";

check_opengl_error :: proc(file: string, line: i32) -> op.GL_Enum {
    ERR_CODE = op.GL_Enum(op.GetError()) // GL_Enum is u64 and GetError returns u32, so cast it

    if ERR_CODE == op.GL_Enum(op.NO_ERROR) {
        return ERR_CODE
    }

    #partial switch ERR_CODE {
        case op.GL_Enum(op.INVALID_ENUM):
            PRINT_ERROR = "GL_INVALID_ENUM";
            break
        case op.GL_Enum(op.INVALID_VALUE):
            PRINT_ERROR = "GL_INVALID_VALUE";
            break
        case op.GL_Enum(op.INVALID_OPERATION):
            PRINT_ERROR = "GL_INVALID_OPERATION";
            break
        case op.GL_Enum(op.STACK_OVERFLOW):
            PRINT_ERROR = "GL_STACK_OVERFLOW";
            break
        case op.GL_Enum(op.STACK_UNDERFLOW):
            PRINT_ERROR = "GL_STACK_UNDERFLOW";
            break
        case op.GL_Enum(op.OUT_OF_MEMORY):
            PRINT_ERROR = "GL_OUT_OF_MEMORY";
            break
        case op.GL_Enum(op.INVALID_FRAMEBUFFER_OPERATION):
            PRINT_ERROR = "GL_INVALID_FRAMEBUFFER_OPERATION";
            break
    }

    fmt.printf("\nOpenGL Error in Line %d and in File: %s\n\tError: %s (Code: %d)\n",
        line,
        file,
        PRINT_ERROR,
        int(ERR_CODE),
    )

    return ERR_CODE
}
