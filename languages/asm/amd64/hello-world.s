;;; Not sure what the standard way of doing things is really.
;;; there seems to be misinformation out there on what pure
;;; amd should look like.
        section .data

        message         db "Hello world", 0xA
	message_len 	equ $ - message

        section .text
        global _start

_start:
        mov rax, 1
        mov rdi, 1
        mov rsi, message
        mov rdx, message_len
        syscall

        jmp halt

halt:
        mov rax, 60
        mov rdi, 0
        syscall
