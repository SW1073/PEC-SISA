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

    ; init palabra estado de retorno
    movi    r1, 0x00
    movhi   r1, 0x00
    wrs    s0, r1

    movi   r1, 0xF
    out     9, r1      ;activa todos los visores hexadecimales
    movi   r1, 0xFF
    out    10, r1      ;muestra el valor 0xFFFF en los visores

    ; init pc retorno
    $MOVEI r1, inici   ;adreça de la rutina principal
    wrs    s1, r1

    ; HACEMOS QUE LA PÁGINA d SEA INVALIDA EN LA TLB DE INSTRUCCIONES
    ; 0x3d = 00_1101 (v=0,r=0,marco=1101)
    movi    r1, 0x0d
    movi    r2, 5
    wrpi    r2, r1
    reti


    ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
    ; Rutina de servicio de interrupcion
    ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
RSG:
    rds    r7, s3
    out    10, r7      ;muestra el identificador de syscall por el hex
    halt


       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
       ; Rutina principal
       ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
inici:

    movi   r1, 0x02
    movhi  r1, 0xd0
    jmp    r1
    halt
