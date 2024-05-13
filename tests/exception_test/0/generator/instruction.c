#include "instruction.h"

char instr_is_legal(instr_t i) {
    switch (OPCODE(i)) {
        // ========================================
        // Qualsevol combinació de bits és vàlida.
        // ========================================
        case ARITLOG:
        case ADDI:
        case MOVI:
        case BRANCH:
        case IO:
        case LD:
        case ST:
        case LDB:
        case STB:
            return 1;

        // ========================================
        // No totes les F son valides
        // ========================================
        case EXTARIT:
            return instr_extarit_is_legal(i);
        case CMP:
            return instr_cmp_is_legal(i);
        case JUMP:
            return instr_jump_is_legal(i);
        case SPECIAL:
            return instr_special_is_legal(i);

        // ========================================
        // Unimplemented
        // ========================================
        case LDF:
        case STF:
        case CMPF:
            return 0;
    }
    return 0;
}

char instr_extarit_is_legal(instr_t i) {
    unsigned char f = R3_F(i);
    return
        f != 0x3 && // -
        f != 0x6 && // -
        f != 0x7;   // -
}

char instr_cmp_is_legal(instr_t i) {
    unsigned char f = R3_F(i);
    return
        f != 0x2 && // -
        f != 0x6 && // -
        f != 0x7;   // -
}

char instr_jump_is_legal(instr_t i) {
    unsigned char f = R2_N6(i);
    return
        f <  0xf && // 42 codis reservats per a fut. ampl.
        f != 0x2 && // -
        f != 0x5 && // -
        f != 0x6 && // -
        f != 0x7;   // CALLS
}

typedef enum {
    EI      = 0x00,
    DI      = 0x01,
    RETI    = 0x04,
    GETIID  = 0x08,
    RDS     = 0x0c,
    WRS     = 0x10,
    // WRPI    = 0x14,
    // WRVI    = 0x15,
    // WRPD    = 0x16,
    // WRVD    = 0x17,
    // FLUSH   = 0x18,
    HALT    = 0x1f,
} f_special_t;

char instr_special_is_legal(instr_t i) {
    unsigned char r1 = SPECIAL_R1(i);
    unsigned char r2 = SPECIAL_R2(i);
    unsigned char e  = SPECIAL_E(i);
    f_special_t f  = SPECIAL_F(i);

    if (e == 0) { // 32 codis reservats per a fut. ampl.
        return 0;
    }

    switch (f) {
        case EI:
        case DI:
        case RETI:
            return r1 == 0x0 && r2 == 0x0;

        case GETIID:
            return r2 == 0x0;

        case RDS:
        case WRS:
            return 1;

        case HALT:
            return i == 0xffff; // r1 == 0x7 && r2 == 0x7;

        default:
            return 0;
    };

}
