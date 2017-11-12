#define NO_THUMB
#include <sysdep.h>
#include <arm-features.h>
#if (!defined (__ARM_ARCH_2__) && !defined (__ARM_ARCH_3__) \
&& !defined (__ARM_ARCH_3M__) && !defined (__ARM_ARCH_4__) \
&& !defined (__ARM_ARCH_4T__) && !defined (__ARM_ARCH_5__) \
&& !defined (__ARM_ARCH_5T__))
#define PLD(code...) code
#else
#define PLD(code...)
	# endif
	.text
	
	
ENTRY(__ieee754_cosh)
	@@ double __ieee754cosh(double x)
	stmfd	sp!, {lr}
	vstmdb.f64	sp!, {d8,d9}

	vmov.f64	d8, d0		@ keep x safe when calling functions
	
	bl	exp	@ get exp(x)

	vmov.f64	d9, d0	@ store in d9

	vmov.f64	d0, d8	@ move x back to d0
	vneg.f64	d0, d0	@ negate x
	
	bl	exp	@ get exp(-x)

	mov	r0, #0x40000000	@ r0:r1 contains 2 as a double
	mov	r1, 0

	vmov.f64	d1, r1, r0 @ load 2 into d1

	vadd.f64	d0, d9, d0	@ d0 = exp(x)+exp(-x)
	vdiv.f64	d0, d0, d1	@ d0 = (exp(x)+exp(-x))/2
	
	vldmia.f64	sp!, {d8,d9}
	ldmfd	sp!, {pc}	@ return sinh(x) in d0
END(__ieee754_cosh)
libc_hidden_builtin_def (__ieee754_cosh)
strong_alias (__ieee754_cosh, __cosh_finite)
