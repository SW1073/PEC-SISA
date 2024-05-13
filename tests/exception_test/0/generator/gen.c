#include <stdio.h>

#define OPCODE(x) ((x & 0xf000) >> 12)

#define R3_R1(x) ((x & 0x0e00) >> 9)
#define R3_R2(x) ((x & 0x01c0) >> 6)
#define R3_F(x) ((x & 0x0038) >> 3)
#define R3_R3(x) ((x & 0x0007))

#define R2_R1(x) ((x & 0x0e00) >> 9)
#define R2_R2(x) ((x & 0x01c0) >> 6)
#define R2_N6(x) ((x & 0x003f))

#define R1_R1(x) ((x & 0x0e00) >> 9)
#define R1_R2(x) ((x & 0x01c0) >> 6)
#define R1_E(x) ((x & 0x0020) >> 5)

#define SPECIAL_R1(x) ((x & 0x0e00) >> 9)
#define SPECIAL_R2(x) ((x & 0x01c0) >> 6)
#define SPECIAL_E(x) ((x & 0x0020) >> 5)
#define SPECIAL_F(x) ((x & 0x001f))

typedef unsigned short instr_t;

enum OP_TYPE {
    _3R,
    _2R,
    _1R,
    _SPECIAL,
};

enum OP_CODE : char {
    ARITLOG     = 0x0,
    CMP         = 0x1,
    ADDI        = 0x2,
    LD          = 0x3,
    ST          = 0x4,
    MOVI        = 0x5,
    BRANCH      = 0x6,
    IO          = 0x7,
    EXTARIT     = 0x8,
    CMPF        = 0x9,
    JUMP        = 0xA,
    LDF         = 0xb,
    STF         = 0xc,
    LDB         = 0xd,
    STB         = 0xe,
    SPECIAL     = 0xf,
};

char instr_is_legal(instr_t i) {
    switch (OPCODE(i)) {
        case ARITLOG:
            return 1;
        case CMP:
            return 0; //TODO
        case ADDI:
            return 1;
        case LD:
            return 1;
        case ST:
            return 1;
        case MOVI:
            return 1;
        case BRANCH:
            return 1;
        case IO:
            return 1;
        case EXTARIT:
            return 0; //TODO
        case CMPF:
            return 0;
        case JUMP:
            return 0; //TODO
        case LDF:
            return 0;
        case STF:
            return 0;
        case LDB:
            return 1;
        case STB:
            return 1;
        case SPECIAL:
            return 0; //TODO
        default:
            return 0;
    }
    return 0;
}

// Struct de una instruccion
struct _3r_t {
    unsigned char r1        : 3;
    unsigned char r2        : 3;
    unsigned char f         : 3;
    unsigned char r3        : 3;
};

struct _2r_t {
    unsigned char r1    : 3;
    unsigned char r2    : 3;
    unsigned char n6    : 6;
};

struct _1r_t {
    unsigned char r1    : 3;
    unsigned char e     : 1;
    unsigned char n8    : 8;
};

struct _special_t {
    unsigned char r1    : 3;
    unsigned char r2    : 3;
    unsigned char b     : 1;
    unsigned char f     : 5;
};


int main() {
    instr_t i;
   for (i = 0; i < 0xffff; i++) {
       printf("i: %x\n", i);
       if (instr_is_legal(i)) {
           printf("Si\n");
       } else {
           printf("No\n");
       }
   }
}

/*
 * viota
 * vmsbf (??)
 * set before first
 */
