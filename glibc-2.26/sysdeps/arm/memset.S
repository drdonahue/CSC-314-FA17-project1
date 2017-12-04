/* Copyright (C) 1998-2017 Free Software Foundation, Inc.
   This file is part of the GNU C Library.
   Contributed by Shashwati Shradha & David Donahue

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library.  If not, see
   <http://www.gnu.org/licenses/>.  */

/********************************************************************//**
Authors:	 Shashwati Shradha, David Donahue

Date:		 4th Dec 2017
	
Function:  	 memset

Prototype:       void* memset( void* ptr, int value, size_t num) ;

parameter:	ptr - Pointer to the block of memory to fill.
		value - value to be set
		num - Number of bytes to be set to the value

Description:
	Fill block of memory
	Set the first num bytes of the block of memory pointed by ptr
	to the specified value.

	To implement this function, we first check if the pointers are
	the same or null pointers. If they are, we immediately go to
	end the program by returning the right values, first num
	characters are set to the passed character value.	

Return:
	ptr - the pointer with first num characters set to value

Speed Analysis:
	The average speed up of the implement compared to the original
	function in the C standard Library is:  -0.74%
	
***********************************************************************/
	#define NO_THUMB
	#include <sysdep.h>
	#include <arm-features.h>
#if (!defined (__ARM_ARCH_2__) && !defined (__ARM_ARCH_3__) \
	&& !defined (__ARM_ARCH_3M__) && !defined (__ARM_ARCH_4__) \
	&& !defined (__ARM_ARCH_4T__) && !defined (__ARM_ARCH_5__) \
	&& !defined (__ARM_ARCH_5T__))
#define PLD(code...)	code
#else
#define PLD(code...)
# endif
	
ENTRY(memset)    
     
	.text
	.globl memset

memset:
	stmfd sp!, {r4, lr}
	
	mov r4, #0			@loads the counter

	cmp r0, #0			@checks if the string is a null pointer
	beq end	
    
loop:
	cmp r4, r2			@checks if num characters are converted
	beq end
    
	strb r1, [r0, r4]		@loads the character value 
        
	add r4, r4, #1
	b loop
    
end:
	ldmfd sp!, {r4, lr}		@returns the pointer to the string
	mov pc, lr
    

END(memset)
libc_hidden_builtin_def (memset)
