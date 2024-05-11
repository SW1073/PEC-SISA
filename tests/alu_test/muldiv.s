movi r0, 64
movi r1, 3
movi r2, 4
movi r3, -2
movi r4, -7
mul r5, r1, r2
st 0(r0), r5
mul r5, r1, r3
st 2(r0), r5
mulh r5, r1, r2
st 4(r0), r5
mulh r5, r1, r3
st 6(r0), r5
mulhu r5, r1, r2
st 8(r0), r5
mulhu r5, r1, r3
st 10(r0), r5
div r5, r2, r1
st 12(r0), r5
div r5, r0, r3
st 14(r0), r5
divu r5, r4, r2
st 16(r0), r5
divu r5, r0, r3
st 18(r0), r5
halt

; Mem[41:40] = 000c parte_baja(3*4)
; Mem[43:42] = fffa 3*(-2)
; Mem[45:44] = 0000 parte_alta(3*4)
; Mem[47:46] = ffff parte_alta(3*(-2))
; Mem[49:48] = 0000 parte_alta(3*4)
; Mem[4b:4a] = 0002 parte_alta(3*fffe = 2fffa)
; Mem[4d:4c] = 0001 4/3
; Mem[4f:4e] = ffe0 64/(-2) = -32
; Mem[51:50] = 3ffe fff9/4 = 3ffe
; Mem[53:52] = 0000 64/fffe = 0
