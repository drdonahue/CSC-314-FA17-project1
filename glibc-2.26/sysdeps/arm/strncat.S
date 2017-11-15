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
ENTRY(strncat)    
  
    .text
	mov r4, #1
	
findNull:
	ldrb r3, [r0], #1
	cmp r3, #0
	bne findNull
    sub r0, r0, #1
    
append:	
    add r4, r4, #1
	
	ldrb r3, [r1], #1
	strb r3, [r0], #1
	
	cmp r3, #0
	beq end
	
	cmp r4, r2
	beq end
	
	b append
	
end:	
	mov pc, lr

END(strncat)
libc_hidden_builtin_def (strncat)
