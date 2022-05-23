.section .data

#Format for inputs and outputs
input_prompt    :   .asciz  "Input a string: "
input_spec      :   .asciz  "%[^\n]"
length_spec     :   .asciz  "String length: %d\n"
palindrome_spec :   .asciz  "String is a palindrome (T/F): %c\n"
input_string    :   .space 8
.section .text

.global main

# program execution begins here
main:
	#Prints "Input a string: "
	ldr x0, =input_prompt
	bl printf

	#Gets input from user
	ldr x0, =input_spec
	ldr x1, =input_string
	bl scanf

	#Loads string, and sets counter to -1 and calls method to get length of string
   	ldr x0, =input_string
	mov x1,#-1
	bl length_loop

#Loop adds 1 to counter, moves pointer in string to next character, compares character to 0 (Strings are 0-terminated so if at 0 then we are at end of string and exit the loop)
length_loop:
	add x1, x1, #1
	ldrb w4,[x0],#1
	cmp w4, #0
	bne length_loop

	#Save length of string 
	stur x1, [sp,#0]
	
	#Output length of string
	ldr x0, =length_spec
	bl printf

	#Load the string, string length, the first index (0), and the last index (string length-1). Store string length in x3
	#If string is null (length of 0) send to palindrome
	ldr x0, =input_string
	mov x1, #0
	ldr x2, [sp,#0]
	mov x3,x2
	sub x2,x2,#1
	cmp x3, #0
	beq palindrome
	bl palindrome_loop

#Iterate forward through string with x1 iterator, iterate backward with x2 iterator, if they do not match at a point then this is not a palindrome and branch to not_palindrome
#If we have completely went through the string then x2 = 0, check for this condition and if true then branch to palindrome
#If neither condition is true then update iterators x1, and x2 and proceed back to top of loop
palindrome_loop:
	ldrb w4, [x0, x1]
	ldrb w5, [x0,x2]
	cmp w4, w5
	bne not_palindrome
	cmp x2, #0
	beq palindrome
	add x1,x1,#1
	sub x2, x2, #1
	bl palindrome_loop

#If palindrome, output 'T'	
palindrome:
	ldr x0, =palindrome_spec
	mov x1, #'T'
	bl printf
	b exit

#If not palindrome, output 'F'
not_palindrome: 
	ldr x0, =palindrome_spec
	mov x1, #'F'
	bl printf
	b exit

# branch to this label on program completion
exit:
    mov x0, 0
    mov x8, 93
    svc 0
    ret
