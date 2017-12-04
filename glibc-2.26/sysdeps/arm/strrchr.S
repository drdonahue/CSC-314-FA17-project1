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
	
Function:  	 strrchr

Prototype:       char* strrchr( const char* str, int charcater) ;

parameter:	str - C string
		character - Character to be located. It is passed as
			    its int promotion

Description:
	Locate the last occurence of charcater in string
	Returns a pointer to the first occurence of character in the
	C string str.

	To implement this function, we first check if the pointer to
	the C string is a nullcharacter. If it is, we immediately
	end the program otherwise we save the first charcater of the
	input string. Then we loop to the find the end of string.
	Then we loop again through the entire string in reverse order
	to find the character. If we find it, we immediately end
	the program otherwise we keep doing so till we reach the
	end of the string. The terminating null character is
	considered to be a part of the string.	

Return:
	A pointer to the last occurence of character in the string
	If character is not found, the function returns a null pointer.

Speed Analysis:
	The average speed up of this implementation as compared to the
	the same function in the C Standard Library is:   -0.91%
	
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
	
ENTRY(strrchr)   
     
	.text
	.globl strrchr

strrchr:
	stmfd sp!, {lr}
	
	cmp r0, #0		@checks if the string is nullptr
	beq end

	ldr r3, [r0]		@stores the first character

findEnd:
	ldrb r2, [r0]		@loops to the end of the string
	cmp r2, #0
	addne r0, r0, #1
	bne findEnd

loop:
	ldrb r2, [r0]   	@gets 1 character from input string
	   	
	cmp r2, r1		@checks if it equal to the input character
	beq end
    
        cmp r2, r3		@checks if the first character of string is reached
	moveq r0, #0		@return nullptr if character not found
        beq end

	sub r0, r0, #1		@moves to the next character in the string
	
        b loop
    
end:	
	ldmfd sp!, {lr}
	mov pc, lr
     
END(strrchr)
libc_hidden_builtin_def (strrchr)
