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

       reti               ; volvemos a modo usuario


       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       ; Rutina de servicio de interrupcion
       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
RSG:   addi   r5, r5, 1
       reti


       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       ; Rutina principal
       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
inici:
       ; RDS, WRS: Los valores de s0 y r0 no deberían cambiar.
       movi   r0, 0x01
       rds    r0, s0
       wrs    s0, r0

       ; EI, DI: El valor de s7 no debería cambiar.
       ei
       di

       ; RETI, GETIID: Se debería continuar el programa después de la excepción.
       reti
       getiid r0

       ; IN, OUT: No deberían generar excepciones.
       in     r0, 5
       out    10, r5      ; Muestra el número de excepciones por el hex. Debería ser 6.

       halt
