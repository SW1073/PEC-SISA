
absolutos:     file format elf32-sisa

Disassembly of section .text:

00000000 <s2-0x20>:
   0:	5000 	movi	r0, 0
   2:	5201 	movi	r1, 1
   4:	540e 	movi	r2, 14
   6:	5603 	movi	r3, 3
   8:	06fa 	shl	r3, r3, r2
   a:	5a20 	movi	r5, 32
   c:	5828 	movi	r4, 40
   e:	5e30 	movi	r7, 48
  10:	5c38 	movi	r6, 56
  12:	090b 	or	r4, r4, r3
  14:	0b4b 	or	r5, r5, r3
  16:	0d8b 	or	r6, r6, r3
  18:	0fcb 	or	r7, r7, r3
  1a:	5440 	movi	r2, 64
  1c:	a100 	jz	r0, r4
  1e:	ffff 	halt	

00000020 <s2>:
  20:	4281 	st	2(r2), r1
  22:	2241 	addi	r1, r1, 1
  24:	a183 	jmp	r6
  26:	ffff 	halt	

00000028 <s1>:
  28:	4280 	st	0(r2), r1
  2a:	2241 	addi	r1, r1, 1
  2c:	a341 	jnz	r1, r5
  2e:	ffff 	halt	

00000030 <s4>:
  30:	4283 	st	6(r2), r1
  32:	4684 	st	8(r2), r3
  34:	4200 	st	0(r0), r1
  36:	ffff 	halt	

00000038 <s3>:
  38:	4282 	st	4(r2), r1
  3a:	2241 	addi	r1, r1, 1
  3c:	a7c4 	jal	r3, r7
  3e:	ffff 	halt	
