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
ENTRY(memset)     
     
     .text
     
    mov r4, #0
    
loop:
    cmp r4, r2
    bge end
    
    ldrb r3, [r0]
    cmp r3, #0
    beq end
    
    strb r1, [r0]!
        
    b loop
    
end: 
    mov pc, lr
    

END(memset)
libc_hidden_builtin_def (memset)
