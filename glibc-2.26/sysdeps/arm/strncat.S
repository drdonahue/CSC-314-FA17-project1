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
	
Function:  	 strncat

Prototype:       char * strncat ( char * destination, const char * source, size_t num );

parameter:	destination - pointer to the destination array which
			      should contain a C string and be large
			      enough to contain the concatenated
			       resulting string
		source      - C string to be appended
		num         - Maximum number of characters to be appended

Description:
	Appends characters from strings
	Appends the first num charcaters of the source string to the
	destination string plus a terminating null character.

	If the length of the C string in source is less than num,
	only the content up to the terminating null character is
	copied.
	
	To implement this function, we first check if the pointers are
	the same or null pointers. If they are, we immediately go to
	end the program by returning the right values, otherwise the
	end of the destination string is found and one character is
	loaded at a time from source to the end of the destination. To
	avoid overflows, the size of the array pointed by destination
	shall be long enough.
	

Return:
	destination - the pointer to the array where the source is
		      copied.

Speed Analysis:
	The average speed up of this implementation as compared to the
	the same function in the C Standard Library is:   -84.21%
	
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
	
ENTRY(strncat)
	.text
	.global strncat
	
strncat:
	stmfd sp!, {r4,r5, lr}

	cmp r0, #0		@checks if string 1 is a nullptr
	beq end

	cmp r1, #0		@checks if string 2 is a nullptr
	beq end

	mov r5, r2		@move n to r5

	mov r3, #0		@counter for offset

findNull:
	ldrb r2, [r0, r3]
		
	cmp r2, #0
	addne r3, r3, #1
	bne findNull

	mov r4, #0
	
loop:
	cmp r4, r5		@checks if added n characters
	beq end
	
	ldrb r2, [r1, r4]	@load 1 character from source

	cmp r2, #0		@checks if it is a null character
	beq end			@ends if it is a null character

	strb r2, [r0, r3]	@stores the character into destination

	add r3, r3, #1		@increases the offset
	add r4, r4, #1
	
	b loop			
	
end:
	mov r4, #0		@adding nullptr
	strb r4, [r0, r3]
	
	ldmfd sp!, {r4,r5, lr}	@returns the source
	mov pc, lr

END(strncat)
libc_hidden_builtin_def (strncat)



