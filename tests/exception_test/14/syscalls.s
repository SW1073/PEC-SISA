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
RSG:   rds    r7, s3      ;obtiene el valor del registro de identificador de la interrupcion
       out    10, r7      ;muestra el identificador de syscall por el hex
       reti


       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       ; Rutina principal
       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
inici:
       movi   r0, 0x02
       calls r0

       movi   r0, 0xca
       calls r0

       movi   r0, 0xfe
       calls r0

       halt
