; NAME: Tony Nguyen
; DATE CREATED: 10/26/16
; CLASS NAME & TIME: CSE 2421 | TTh 5:20 - 7:20
; CSE2421 IDENTIFIER: 0X05194C41

USE32 ; tell nasm to assemble 32 bit code

global _start ; export the start symbol for program
_start: ; tell the linker where the program begins

; BEGINNING OF PROGRAM

; MY CODE HERE

	call read_integer ; n = read integer
	mov ecx, 0 ;i = 0 

	while_not_zero: ; while n != 0
	cmp eax, 0 ; n compared to 0
	je done_while ; jump to end of while loop if 0
	mov ebx, 1 ; is_prime = true

	if_one: ; if n == 1
	cmp eax, 1 ; n compared to 1
	jne if_not_one ; jump if not equal to 1
	jmp is_prime_false

	if_not_one: ; else statement

	mov ecx, 2
	for_loop:
	
	mov edi, eax ;temporarily backup n (eax)
	mov eax, ecx ; eax is now i
	mov edx, 0 ; clear high 32 bits
	mul eax ; square i
	mov esi, eax ; store i^2 in esi
	mov eax, edi ; store n back into eax
	cmp esi, eax ; i^2 compared to n
	ja done_for ; jump if i^2 > n 

	mov edx, 0 ;clear the high 32 bits just in case for the remainder
	div ecx ; eax/ecx = n/i, remainder stored in edx
	;eax has now been "clobbered" - modified
	cmp edx, 0 ; cmp if n%i==0
	je is_prime_false ; if equal, jump to is_prime_false 
	

	inc ecx ;increment i
	mov eax, edi ;move n back into eax using the backup edi
	jmp for_loop ;jump back to for_loop

	is_prime_false: ; if not prime, set ebx to 0
	mov ebx, 0

	done_for: ;end of for loop
	
	cmp ebx, 1 ; compare ebx to 1
	jne is_not_prime ; if not 1, then not prime, jump
	call print_prime ; if true (1), call print_prime
	jmp continue ; continue with while loop
	is_not_prime: ; if not prime, call print_not prime
	call print_not_prime

	continue: ; continue with while loop

	call read_integer ; n = read int
	jmp while_not_zero ; go back to while loop and check condition
	done_while: ; exit while loop

; EXIT
	mov ebx, 0
	mov eax, 1
	int 80h

; functions here
print_not_prime:
; set up stack frame
	push ebp ; save the current stack frame
	mov ebp, esp ; set up a new stack frame

; save modified registers
	push eax ; save eax
	push ebx ; save ebx
	push ecx ; save ecx
	push edx ; save edx

; write not prime to stdout
	mov eax, 4 ; syscall 4 (write)
	mov ebx, 1 ; file descriptor (stdout)
	mov ecx, .not_prime ; pointer to data to load
	mov edx, .not_prime.l ; byte count
	int 0x80 ; issue system call

; cleanup
	pop edx ; restore edx
	pop ecx ; restore ecx
	pop ebx ; restore ebx
	pop eax ; restore eax
	pop ebp ; restore ebp
	ret ; return to caller

.not_prime: db "not prime", 10
.not_prime.l equ $-.not_prime

print_prime:
; set up stack frame
	push ebp ; save the current stack frame
	mov ebp, esp ; set up a new stack frame

; save modified registers
	push eax ; save eax
	push ebx ; save ebx
	push ecx ; save ecx
	push edx ; save edx

; write prime to stdout
	mov eax, 4 ; syscall 4 (write)
	mov ebx, 1 ; file descriptor (stdout)
	mov ecx, .prime ; pointer to data to load
	mov edx, .prime.l ; byte count
	int 0x80 ; issue system call

; cleanup
	pop edx ; restore edx
	pop ecx ; restore ecx
	pop ebx ; restore ebx
	pop eax ; restore eax
	pop ebp ; restore ebp
	ret ; return to caller

.prime: db "prime", 10
.prime.l equ $-.prime

read_integer:
; set up stack frame
	push ebp ; save the current stack frame
	mov ebp, esp ; set up a new stack frame

; set up local variables
	sub esp, 8 ; allocate space for two local ints
	mov dword [ebp-4], '0' ; digit: initialize to '0'
	mov dword [ebp-8], 0 ; value: initialize to 0

; save modified registers
	push ebx ; save ebx
	push ecx ; save ecx
	push edx ; save edx

.read_loop:

; update number calculation
	mov eax, 10 ; load multiplier
	mul dword [ebp-8] ; multiply current value by 10, store in eax
	add eax, [ebp-4] ; add new digit to current value
	sub eax, '0' ; convert digit character to numerical equivalent
	mov [ebp-8], eax ; save new value

; read in digit from user
	mov eax, 3 ; syscall 3 (read)
	mov ebx, 0 ; file descriptor (stdin)
	lea ecx, [ebp-4] ; pointer to data to save to
	mov edx, 1 ; byte count
	int 0x80 ; issue system call

; loop until enter is pressed
	cmp dword [ebp-4], 10 ; check if end of line reached
	jne .read_loop ; if not, continue reading digits

; cleanup
	mov eax, [ebp-8] ; save final value in eax
	pop edx ; restore edx
	pop ecx ; restore ecx
	pop ebx ; restore ebx
	add esp, 8 ; free local variables
	pop ebp ; restore ebp
	ret ; return to caller
