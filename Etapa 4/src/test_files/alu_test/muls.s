movi r0, 0
movi r1, 1
movi r2, 2
mul r3, r1, r2 ; 0002
mulh r4, r1, r2 ; 0000
mulhu r5, r1, r2 ; 0000
st 0(r0), r3
st 2(r0), r4
st 4(r0), r5
movi r2, 0xff
movhi r2, 0x7f
mul r3, r1, r2 ; 7fff
mulh r4, r1, r2 ; 0000
mulhu r5, r1, r2 ; 0000
st 6(r0), r3
st 8(r0), r4
st 10(r0), r5
movhi r2, 0xff
mul r3, r1, r2 ; ffff
mulh r4, r1, r2 ; ffff
mulhu r5, r1, r2 ; 0000
st 12(r0), r3
st 14(r0), r4
st 16(r0), r5
movi r1, 0xff
mul r3, r1, r2 ; 0001
mulh r4, r1, r2 ; 0000
mulhu r5, r1, r2 ; fffe
st 18(r0), r3
st 20(r0), r4
st 22(r0), r5
movi r1, 0
movhi r1, 0x80
mul r3, r1, r2 ; 8000
mulh r4, r1, r2 ; 0000
mulhu r5, r1, r2 ; 7fff
st 24(r0), r3
st 26(r0), r4
st 28(r0), r5
halt

Mem[01:00] = 0002
Mem[03:02] = 0000
Mem[05:04] = 0000
Mem[07:06] = 7fff
Mem[09:08] = 0000
Mem[0b:0a] = 0000
Mem[0d:0c] = ffff
Mem[0f:0e] = ffff
Mem[11:10] = 0000
Mem[13:12] = 0001
Mem[15:14] = 0000
Mem[17:16] = fffe
Mem[19:18] = 8000
Mem[1b:1a] = 0000
Mem[1d:1c] = 7fff
