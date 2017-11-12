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
ENTRY(strcpy)
    .text
    
loop:	
    ldrb r2, [r1]!,   
	cmp r2, #0
	b end

	strb r2, [r0]!
	b loop
	
end:	
    mov r2,#0
	strb r2, [r0]
	mov pc, lr

END(strcpy)
libc_hidden_builtin_def (strcpy)
