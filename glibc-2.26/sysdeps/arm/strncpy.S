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
ENTRY(strncpy)
    .text
    
	mov r4, #0
	
loop:	
    ldrb r3, [r1], #1
	cmp r3, #0
	b exit

	add r4, r4, #1
	cmp r4, r2
	bgt exit

	strb r3, [r0], #1
	b loop
	
exit:	cmp r4, r2
	bgt end

padding:
	cmp r4, r2
	beq end
	mov r3, #0
	strb r3, [r0], #1
	b  padding
	
end:	mov pc, lr

END(strncpy)
libc_hidden_builtin_def (strncpy)
