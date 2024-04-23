movi r0, 0
movi r1, 1
movi r2, 2
div r3, r2, r1 ; 0002
divu r4, r2, r1 ; 0002
st 0(r0), r3
st 2(r0), r4
movi r2, 0xff
movhi r2, 0x7f
div r3, r1, r2 ; 0000
divu r4, r1, r2 ; 0000
st 4(r0), r3
st 6(r0), r4
movhi r2, 0xff
div r3, r1, r2 ; ffff
divu r4, r1, r2 ; 0000
st 8(r0), r3
st 10(r0), r4
movi r1, 0xff
div r3, r1, r2 ; 0001
divu r4, r1, r2 ; 0001
st 12(r0), r3
st 14(r0), r4
movi r1, 0
movhi r1, 0x80
div r3, r1, r2 ; 0000
divu r4, r1, r2 ; 0000
st 16(r0), r3
st 18(r0), r4
halt

; Mem[01:00] = 0002
; Mem[03:02] = 0002
; Mem[05:04] = 0000
; Mem[07:06] = 0000
; Mem[09:08] = ffff
; Mem[0b:0a] = 0000
; Mem[0d:0c] = 0001
; Mem[0f:0e] = 0001
; Mem[11:10] = xxxx (overflow)
; Mem[13:12] = 0000
