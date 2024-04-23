
logicas:     file format elf32-sisa

Disassembly of section .text:

00000000 <.text>:
   0:	5000 	movi	r0, 0
   2:	527d 	movi	r1, 125
   4:	5333 	movhi	r1, 51
   6:	5468 	movi	r2, 104
   8:	5543 	movhi	r2, 67
   a:	0642 	and	r3, r1, r2
   c:	4600 	st	0(r0), r3
   e:	084a 	or	r4, r1, r2
  10:	4801 	st	2(r0), r4
  12:	0a98 	not	r5, r2
  14:	4a02 	st	4(r0), r5
  16:	0c52 	xor	r6, r1, r2
  18:	4c03 	st	6(r0), r6
  1a:	ffff 	halt	

op   rd  ra  f   rb
0000 101 010 011 000
