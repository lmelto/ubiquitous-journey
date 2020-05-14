extern	_printf
extern	_scanf

SECTION	.data

	_printf_prompt		db	"How many disks do you want to play with? ",	0
	_printf_invalid		db	"Uh-oh, I couldn't understand that... No towers of Hanoi for you!",	10,	0
	_printf_move		db	"Move disk %d from %d to %d",	10,	0
	_num_disks			dd	0
	str_pattern			db	"%d",	0
	
SECTION	.text

global	_main
_main:
	push	ebp
	mov		ebp,	esp

	push	_printf_prompt
	call	_printf
	add		esp,	4
	push	_num_disks
	push	str_pattern
	call	_scanf
	add 	esp,	8
	cmp		eax,	1
	je		_valid
	jmp		_invalid

_valid:
	cmp		dword [_num_disks],	0
	jg		_non_zero
	jmp		_invalid
	
_non_zero:
	push	3
	push	2
	push	1
	push	dword 	[_num_disks]
	call	_hanoi
	add		esp,	16
	mov		esp,	ebp
	pop		ebp
	ret
	
_invalid:
	push	_printf_invalid
	call	_printf
	add		esp,	4
	mov		esp,	ebp
	pop		ebp
	ret		1
	
	
global	_hanoi
_hanoi:
	push	ebp
	mov		ebp,	esp
	
	push	ebx
	mov		ebx,	[ebp + 8]
	
	cmp		ebx,	1
	je		_equal_one
	jmp		_not_equal_one
	
_equal_one:
	push	dword	[ebp + 16]
	push	dword	[ebp + 12]
	push	dword	[ebp + 8]
	push	_printf_move
	call	_printf
	add		esp,	16
	pop		ebx
	mov		esp,	ebp
	pop		ebp
	ret

_not_equal_one:
	sub		ebx,	1
	
	push	dword	[ebp + 16]
	push	dword	[ebp + 20]
	push	dword	[ebp + 12]
	push	ebx
	call	_hanoi
	add		esp,	16
	
	push	dword	[ebp + 16]
	push	dword	[ebp + 12]
	push	dword	[ebp + 8]
	push	_printf_move
	call	_printf
	add		esp,	16
	
	push	dword	[ebp + 12]
	push	dword	[ebp + 16]
	push	dword	[ebp + 20]
	push	ebx
	call	_hanoi
	add		esp,	16
	
	mov		esp,	ebp
	pop		ebp
	ret
