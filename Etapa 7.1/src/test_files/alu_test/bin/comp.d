
comp:     file format elf32-sisa

Disassembly of section .text:

00000000 <.text>:
   0:	5000 	movi	r0, 0
   2:	5202 	movi	r1, 2
   4:	5402 	movi	r2, 2
   6:	5603 	movi	r3, 3
   8:	58ff 	movi	r4, -1
   a:	1a83 	cmplt	r5, r2, r3
   c:	4a00 	st	0(r0), r5
   e:	1b02 	cmplt	r5, r4, r2
  10:	4a01 	st	2(r0), r5
  12:	1a42 	cmplt	r5, r1, r2
  14:	4a02 	st	4(r0), r5
  16:	1ac0 	cmplt	r5, r3, r0
  18:	4a03 	st	6(r0), r5
  1a:	1a8b 	cmple	r5, r2, r3
  1c:	4a04 	st	8(r0), r5
  1e:	1b0a 	cmple	r5, r4, r2
  20:	4a05 	st	10(r0), r5
  22:	1a4a 	cmple	r5, r1, r2
  24:	4a06 	st	12(r0), r5
  26:	1ac8 	cmple	r5, r3, r0
  28:	4a07 	st	14(r0), r5
  2a:	1a9b 	cmpeq	r5, r2, r3
  2c:	4a08 	st	16(r0), r5
  2e:	1b1a 	cmpeq	r5, r4, r2
  30:	4a09 	st	18(r0), r5
  32:	1a5a 	cmpeq	r5, r1, r2
  34:	4a0a 	st	20(r0), r5
  36:	1ad8 	cmpeq	r5, r3, r0
  38:	4a0b 	st	22(r0), r5
  3a:	1aa3 	cmpltu	r5, r2, r3
  3c:	4a0c 	st	24(r0), r5
  3e:	1b22 	cmpltu	r5, r4, r2
  40:	4a0d 	st	26(r0), r5
  42:	1a62 	cmpltu	r5, r1, r2
  44:	4a0e 	st	28(r0), r5
  46:	1ae0 	cmpltu	r5, r3, r0
  48:	4a0f 	st	30(r0), r5
  4a:	1aab 	cmpleu	r5, r2, r3
  4c:	4a10 	st	32(r0), r5
  4e:	1b2a 	cmpleu	r5, r4, r2
  50:	4a11 	st	34(r0), r5
  52:	1a6a 	cmpleu	r5, r1, r2
  54:	4a12 	st	36(r0), r5
  56:	1ae8 	cmpleu	r5, r3, r0
  58:	4a13 	st	38(r0), r5
  5a:	ffff 	halt	
