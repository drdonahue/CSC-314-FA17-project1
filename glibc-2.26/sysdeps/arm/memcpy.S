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
ENTRY(memcpy)
    .text
    
    mov r4, #0
loop:	
    cmp r4, r2
    bge end
    
    ldrb r3, [r1], #1
	strb r3, [r0], #1
	
	add r4, r4, #1
	
	b loop
	
end:	
	mov pc, lr

END(memcpy)
libc_hidden_builtin_def (memcpy)
