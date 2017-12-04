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
	
Function:  	 strncpy

Prototype:       char * strncpy ( char * destination, const char * source, size_t num );

parameter:	destination - pointer to the destination array where
			      the content is to be copied
		source      - C string to be copied
		num	    - Maximum number of characters to be copied

Description:
	Copy characters from string
	Copies the C string pointer by source into the array pointed
	by destination, including terminating null character ( and
	stopping at that point).

	To implement this function, we first check if the pointers are
	the same or null pointers. If they are, we immediately go to
	end the program by returning the right values, otherwise it
	one character at a time from source to destination. 

	If the end of the source C string(which is signaled by a null
	character) is found before num characters have been copied,
	destination is padded with zeros until a total of num
	characters have been written to it.

	No null-character is implicitly appended at the end of destination
	if source is longer than num. Thus, in case, destination shall
	not be considered a null-terminated C string(reading it as
	such would overflow).

Return:
	destination - the pointer to the array where the source is
		      copied.

Speed Analysis:
	The average speed up of this implementation as compared to the
	the same function in the C Standard Library is:   -13.20%
	
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
	
ENTRY(strncpy)
	.text
	.global strncpy
	
strncpy:
	stmfd sp!, {r4, lr}

	cmp r0, #0		@checks if string 1 is a nullptr
	beq end

	cmp r1, #0		@checks if string 2 is a nullptr
	beq end

	mov r4, r2		@storing n in r4
	
	mov r3, #0		@counter for offset

loop:
	cmp r3, r4		@checks if r3 = n
	beq end
	
	ldrb r2, [r1, r3]	@load 1 character from source

	strb r2, [r0, r3]	@stores the character into destination

	add r3, r3, #1		@increases the offset

	cmp r2, #0		@checks if it is a null character
	beq end_before		@go for padding
	
	b loop

end_before:			@if the string ends before num
	cmp r3, r4		@characters are copied.
	beq end
	
	strb r2, [r0, r3]	@pad destination with zeros
	add r3, r3, #1
	
	b  end_before
	
end:
	ldmfd sp!, {r4, lr}	@returns the destination
	mov pc, lr

END(strncpy)
libc_hidden_builtin_def (strncpy)

