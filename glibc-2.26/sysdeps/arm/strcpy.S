/* Copyright (C) 1998-2017 Free Software Foundation, Inc.
   This file is part of the GNU C Library.
   Contributed by Philip Blundell <philb@gnu.org>

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
	
Function:  	 strcpy

Prototype:       char* strcpy( char* destination, const char* source) ;

parameter:	destination - pointer to the destination array where
			      the content is to be copied
		source      - C string to be copied

Description:
	Copy strings
	Copies the C string pointer by source into the array pointed
	by destination, including terminating null character ( and
	stopping at that point).

	To implement this function, we first check if the pointers are
	the same or null pointers. If they are, we immediately go to
	end the program by returning the right values, otherwise it
	one character at a time from source to destination. To
	avoid overflows, the size of the array pointed by
	destination shall be long enough to contain the same C string
	as souce( including the terminating null character).
	

Return:
	destination - the pointer to the array where the source is
		      copied.

Speed Analysis:
	The average speed up in the implement is :
	
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
	
ENTRY(strcpy)
	.text
	.global strcpy
	
strcpy:
	stmfd sp!, {lr}

	cmp r0, #0		@checks if string 1 is a nullptr
	beq end

	cmp r1, #0		@checks if string 2 is a nullptr
	beq end

	mov r3, #0		@counter for offset

loop:
	ldrb r2, [r1, r3]	@load 1 character from source

	strb r2, [r0, r3]	@stores the character into destination

	cmp r2, #0		@checks if it is a null character
	beq end			@ends if it is a null character

	add r3, r3, #1		@increases the offset
	
	b loop			
	
end:
	ldmfd sp!, {lr}		@returns the source
	mov pc, lr

END(strcpy)
libc_hidden_builtin_def (strcpy)
