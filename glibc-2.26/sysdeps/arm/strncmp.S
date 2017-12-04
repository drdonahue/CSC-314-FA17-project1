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
	
Function:  	 strncmp

Prototype:       int strncmp( const char* str1, const char* str2, size_t num) ;

parameter:	str1 - pointer to the first C string
		str2 - pointer to the second C string

Description:
	Compares two strings
	Compare the C string str1 to the C string st2.

	To implement this function, we first check if the pointers are
	the same or null pointers. If they are, we immediately go to
	end the program by returning the right values, otherwise
	it starts comparing the first character of each string.
	If they are equal to each other, it continues with the
	following pairs until the characters differ or until a
	terminating null character is reached or until we have
	compared num characters.

Return:
	<0 the first character that does not match has a lower value
	   in str1 than in str2
	 0 the content of both strings are equal
	>0 the first character that does not match has a higher value
	   in str1 than in str2

Speed Analysis:
	The average speed up of this implementation as compared to the
	the same function in the C Standard Library is:   -14.42%
	
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
	
ENTRY(strncmp)
	.text
	.global strncmp
	
strncmp:
	stmfd sp!, {r4- r6, lr}
	
	cmp r0, r1          @checks if the strings are same
	moveq r4, #0
	beq end
	
	cmp r0, #0          @checks if the first string is a nullptr
	moveq r4, #-1
	beq end
	
	cmp r1, #0          @checks if the second string is a nullptr
	moveq r4, #1
	beq end
	
	mov r5, #0	    @counter for the length
	mov r6, r2	    @ n
	
loop:		
	cmp r5, r6	        @compare the length with
	beq end
	
	ldrb r2, [r0, r5]        @loads 1 character from the string1
	ldrb r3, [r1, r5]        @loads 1 character form the string2
    
	subs r4, r2, r3          @checks if characters are equal
	bne end
    
	cmp r2, #0		 @checks if it reached the end of string1
	beq end			     
    
	cmp r3, #0               @checks if it reached the end of string2
	beq end
	
	add r5, r5, #1	        @increases the counter by 1
    
	b loop
    
end:
	mov r0, r4		     @returns the value(+/0/-)
	ldmfd sp!, {r4-r6, lr}
	mov pc, lr

END(strncmp)
libc_hidden_builtin_def (strncmp)
