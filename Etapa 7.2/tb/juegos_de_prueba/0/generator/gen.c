#include <stdio.h>
#include "instruction.h"

int main() {
    instr_t i;
   for (i = 0; i < 0xffff; i++) {
       if (!instr_is_legal(i)) {
           printf("%x\n", i);
       }
   }
}
