.macro $movei p1 imm16
        movi    \p1, lo(\imm16)
        movhi   \p1, hi(\imm16)
.endm


.text
       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       ; Inicializacion
       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       ; init @RSG
       $MOVEI r1, RSG
       wrs    s5, r1

       ; init pc retorno
       $MOVEI r1, inici   ;adreça de la rutina principal
       wrs    s1, r1

       ; init palabra estado de retorno
       movi    r1, 0x00
       movhi   r1, 0x00
       wrs    s0, r1

       movi   r1, 0xF
       out     9, r1      ;activa todos los visores hexadecimales
       movi   r1, 0xFF
       out    10, r1      ;muestra el valor 0xFFFF en los visores

       reti


       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       ; Rutina de servicio de interrupcion
       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
RSG:   rds    r7, s2      ;obtiene el valor del registro de estado. Nos dice que excepción ha ocurrido
       addi   r5, r5, 1
       out    10, r5      ;muestra el numero de excepciones atendidas hasta en el momento
       reti


       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       ; Rutina principal
       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
inici:
       movi   r0, 0x02
       movhi  r0, 0x80

       st    0(r0), r1
       ld    r1, 0(r0)
       stb   0(r0), r1
       ldb   r1, 0(r0)
       halt
