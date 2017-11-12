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
ENTRY(strcmp)
	.text
	
loop:
	ldrb r2, [r0]!
	ldrb r3, [r1]!
	sub r4, r2, r3
	
	cmp r2, #0
	b end
	
	cmp r3, #0
	b end
	
	b loop
	
end:	mov r0, r4
	mov pc, lr
	
END(strcmp)
libc_hidden_builtin_def (strcmp)

