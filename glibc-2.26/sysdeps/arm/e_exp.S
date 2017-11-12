	#define NO_THUMB
	#include <sysdep.h>
	#include <arm-features.h>
	#if (!defined (__ARM_ARCH_2__) && !defined (__ARM_ARCH_3__) \
	&& !defined (__ARM_ARCH_3M__) && !defined (__ARM_ARCH_4__) \
	&& !defined (__ARM_ARCH_4T__) && !defined (__ARM_ARCH_5__) \
	&& !defined (__ARM_ARCH_5T__))
	#define PLD(code...)    code
	#else
	#define PLD(code...)
	# endif

	.data

table:  @@ Constant values of 1/n! needed for the taylor series
	@@ approximation, encoded as double precsion floats 
	.word 0x00000000, 0x3FF00000 @ 1/1!
	.word 0x00000000, 0x3FE00000 @ 1/2!
	.word 0x55555555, 0x3FC55555 @ 1/3!
	.word 0x55555555, 0x3FA55555 @ 1/4!
	.word 0x11111111, 0x3F811111 @ 1/5!
	.word 0x16C16C17, 0x3F56C16C @ 1/6!
	.word 0x1A01A01A, 0x3F2A01A0 @ 1/7!
	.word 0x1A01A01A, 0x3EFA01A0 @ 1/8!
	.word 0xA556C734, 0x3EC71DE3 @ 1/9!
	.word 0xB7789F5C, 0x3E927E4F @ 1/10!
	.word 0x67F544E4, 0x3E5AE645 @ 1/11!
	.word 0xEFF8D898, 0x3E21EED8 @ 1/12!
	.word 0x13A86D09, 0x3DE61246 @ 1/13!
	.word 0xA8C07C9D, 0x3DA93974 @ 1/14!
	.word 0xE733B81F, 0x3D6AE7F3 @ 1/15!
	.word 0xE733B81F, 0x3D2AE7F3 @ 1/16!
	.word 0x7030AD4A, 0x3CE952C7 @ 1/17!
	.word 0x63B97D97, 0x3CA68278 @ 1/18!
	.word 0x46814157, 0x3C62F49B @ 1/19!

	.equ	TERMS, 19

	.text
	ENTRY(__ieee754_exp)
	@@ double __ieee754_exp(double x)
	@@ d0 contains x at start
	@@ return value is d0
	ldr	r0, =table	@ get the pointer to the table of 
				@ constants
	mov	r1, #0		@ Keep track of itterations

	vldr.f64	d1, [r0]	       @ the first element is 1
	vmov.f64	d2, d1 @ set d2 to 1. this will accumulate.
	
loop:	vldr.f64	d3, [r0]@ Load a value from the table
	add	r0, r0, #8	@ increment the table location
	vmul.f64	d1, d0, d1 @ Get the next power of x
	vmul.f64	d4, d1, d3 @ multiply by the constant
	vadd.f64	d2, d2, d4
	add	r1, r1, #1	@ increment the term counter
	cmp	r1, #TERMS
	blt	loop

	vmov.f64	d0, d2
	
	mov     pc,lr           @ return from function
	END(__ieee754_exp)
	#ifndef __ieee754_exp
	strong_alias (__ieee754_exp, __exp_finite)
	strong_alias (__ieee754_exp, __exp1)
	#endif
