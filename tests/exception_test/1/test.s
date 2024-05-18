.macro $movei p1 imm16
        movi    \p1, lo(\imm16)
        movhi   \p1, hi(\imm16)
.endm


.text
       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       ; Inicializacion
       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       $MOVEI r1, RSG
       wrs    s5, r1      ;inicializamos en S5 la direccion de la rutina de antencion a las interrupcciones
       movi   r1, 0xF
       out     9, r1      ;activa todos los visores hexadecimales
       movi   r1, 0xFF
       out    10, r1      ;muestra el valor 0xFFFF en los visores
       $MOVEI r6, inici   ;adreça de la rutina principal
       jmp    r6

       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       ; Rutina de servicio de interrupcion
       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
RSG:   rds    r7, s2      ;obtiene el valor del registro de estado. Nos dice que excepción ha ocurrido
       addi   r6, r6, 1
       out    10, r6      ;muestra el numero de excepciones atendidas hasta en el momento
       reti


       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       ; Rutina principal
       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
inici:
       di                 ;desactiva las interrupciones
       movi   r0, 0xAA
       movhi  r0, 0xAA

       ; ST y LD legales
       movi   r1, 0
       st    0(r1), r0
       st    2(r1), r0

       ; ST y LD ilegales
       movi   r1, 1
       st     0(r1), r2
       ld     r2, 0(r1)

       ; STB y LDB (legales)
       movi   r1, 1
       stb    0(r1), r0
       ldb    r2, 0(r1)
       halt
