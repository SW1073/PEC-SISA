
relativos:     file format elf32-sisa

Disassembly of section .text:

00000000 <a-0xa>:
   0:	5000 	movi	r0, 0
   2:	5201 	movi	r1, 1
   4:	5402 	movi	r2, 2
   6:	6201 	bz	r1, 4
   8:	4200 	st	0(r0), r1

0000000a <a>:
   a:	4401 	st	2(r0), r2
   c:	6001 	bz	r0, 4
   e:	4202 	st	4(r0), r1

00000010 <b>:
  10:	6301 	bnz	r1, 4
  12:	4403 	st	6(r0), r2

00000014 <c>:
  14:	6101 	bnz	r0, 4
  16:	4204 	st	8(r0), r1

00000018 <d>:
  18:	ffff 	halt	
