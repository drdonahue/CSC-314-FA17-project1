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
ENTRY(strlen)
    .text
    
    mov r3, #0
    
loop:
    ldbr r1, [r0], #1
    cmp r1, #0
    beq end
        
    add r3, r3, #1
    b loop
    
end:
    mov r0, r3
    mov pc, lr
    
END(strlen)
libc_hidden_builtin_def (strlen)
