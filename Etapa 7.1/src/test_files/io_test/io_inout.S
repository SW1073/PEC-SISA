    movi r0, 0x00
a:  in r1, 8
    out 10, r1
    bz r0, a
    halt
