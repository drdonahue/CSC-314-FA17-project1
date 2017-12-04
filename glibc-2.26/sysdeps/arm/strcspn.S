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
	
ENTRY(strcspn) 
	.text
	.globl	strcspn
strcspn:	
	cmp	r0, #0
	cmpne	r1, #0
	moveq	pc,lr
	
	stmfd	sp!, {r4,lr}

	mov	r4, #0

loop1:	mov	r12, r1
	ldrb	r2, [r0]!	@ load a character from r0
loop2:
	ldrb	r3, [r12]!	@ compare to each character in r1
	cmp	r2, r3
	beq	end		@ if a match is found, end the function

	cmp	r3, #0		@ else check the character string for null
	bne	loop2		@ if null, move on to the next character of r0

	add	r4, r4, #1	@ increment the count
	cmp	r2, #0		@ compare str1 to null, though the match should catch it
	bne	loop1		@ if not null, move on to the next character

end:	mov	r0, r4

	ldmfd 	sp!, {r4,pc}

	
END(strcspn)
libc_hidden_builtin_def (strcspn)
