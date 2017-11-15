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
ENTRY(strcat)
    
    .text
	
findNull:
	ldrb r2, [r0], #1
	cmp r2, #0
	bne findNull
    sub r0, r0, #1
    
append:
	ldrb r2, [r1], #1
	strb r2, [r0], #1
	cmp r2, #0
	bne append

	mov pc, lr


END(strcat)
libc_hidden_builtin_def (strcat)

