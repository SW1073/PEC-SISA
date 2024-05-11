movi r0, 32
movi r1, 0xAB
wrs s0, r1 ; una palabra de estado inventada
movi r1, 0x10
movhi r1, 0xC0
wrs s1, r1
reti
halt ; este halt no deberia ejecutarse si reti funciona
rds r5, s7
st 0(r0), r5
halt
