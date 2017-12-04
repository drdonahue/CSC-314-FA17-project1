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
	
Function:  	 strlen

Prototype:       char* strlen(const char* str) ;

parameter:	 str - C string

Description:
	Get string length
	The length of a C string is determined by the terminating null
	character. A C string is as long as the number of charcaters
	between the beginning of the string and the terminating null
	character(without including the terminating null character
	itself).

	To implement this function, we first check if the pointers are
	the same or null pointers. If they are, we immediately go to
	end the program by returning 0. Otherwise we loop until we
	find the null character. As soon as we reach the null
	character, the program ends and returns the length of the
	string.
	
Return:
	The length of the string.

Speed Analysis:
	The average speed up of this implementation as compared to the
	the same function in the C Standard Library is:   -96.91%
	
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

ENTRY(strlen)
	
	.text
	.global strlen
	
strlen:
	stmfd sp!, {lr}
	mov r3, #0		@counter for the length

	cmp r0, #0
	beq end
loop:
	ldrb r1, [r0, r3]	@loads 1 character from the word
	cmp r1, #0		@compares to check if it is nullptr
	beq end			@branches to the end if it is nullptr
        
	add r3, r3, #1		@adds 1 to the length counter
	b loop
    
end:
	mov r0, r3		@returns the length
	ldmfd sp!, {lr}
	mov pc, lr

END(strlen)
libc_hidden_builtin_def (strlen)
