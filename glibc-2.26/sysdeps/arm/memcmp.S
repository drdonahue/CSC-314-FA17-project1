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
	
	ENTRY(memcmp)

	.text
	.globl memcmp
memcmp:	

	stmfd	sp!, {r4,lr}

loop:	ldrb	r3, [r0]!	@ grab a byte from each array
	ldrb	r12, [r1]!	@ 
	subs	r4, r3, r12	@ subs will give the difference and set the flags
	bne	end		@ if not equal, end the function
	sub	r2, r2, #1	@ decrement the number of bytes to check
	cmp	r2, #0
	bne	loop		@ loop
	
end:	mov	r4, r0		@ return the result of the last subtract
	
	ldmfd	sp!, {r4,pc}


END(memset)
libc_hidden_builtin_def (memset)
	
