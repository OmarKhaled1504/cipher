include 'emu8086.inc'

org 100h

jmp start

.data
string1     db  100        ;MAX NUMBER OF CHARACTERS ALLOWED (25).
            db  ?         ;NUMBER OF CHARACTERS ENTERED BY USER.
            db  100 dup(0) ;CHARACTERS ENTERED BY USER
table1 db 97 dup (' '), 'qwertyuiopasdfghjklzxcvbnm';encryption table
table2 db 97 dup (' '), 'kxumcnophqrszyijadlewgbvft';decryption table

.code
start:
;text input
print 'Enter text to be encrypted/decrypted:'

mov ax, @data
mov ds, ax
mov ah, 0ah
mov dx, offset string1
int 21h
mov si, offset string1 + 1      ;NUMBER OF CHARACTERS ENTERED.
mov cl, [ si ]                  ;MOVE LENGTH TO CL.
mov ch, 0                       ;CLEAR CH TO USE CX. 
inc cx                          ;TO REACH CHR(13).
add si, cx                      ;NOW SI POINTS TO CHR(13).
mov al, '$'
mov [ si ], al                  ;REPLACE CHR(13) BY '$'.   
printn

;encryption
lea bx, table1
lea si, string1
call encrypt

print 'Encrypted text:'
lea dx, string1
; output of a string at ds:dx
mov ah, 9 
mov dx, offset string1 + 2 ;MUST END WITH '$'.
int 21h 
printn




; decryption
lea bx, table2
lea si, string1
call decrypt

print 'Decrypted text:'
lea dx, string1
; output of a string at ds:dx
mov ah, 9 
mov dx, offset string1 + 2 ;MUST END WITH '$'.
int 21h


; wait for any key...
mov ah, 0
int 16h


ret   ; exit to operating system.




; subroutine to encrypt
; parameters: 
;             si - address of string to encrypt
;             bx - table to use.
encrypt proc near

next_char:
	cmp [si], '$'      ; end of string?
	je end_of_string
	
	mov al, [si]
	cmp al, 'a'
	jb  skip
	cmp al, 'z'
	ja  skip	
	xlatb     ; encrypt using table2  
	mov [si], al
skip:
	inc si	
	jmp next_char

end_of_string:


ret
encrypt endp 

decrypt proc near

next_char2:
	cmp [si], '$'      ; end of string?
	je end_of_string2
	
	mov al, [si]
	cmp al, 'a'
	jb  skip2
	cmp al, 'z'
	ja  skip2	
	xlatb     ; decrypt using table1  
	mov [si], al
skip2:
	inc si	
	jmp next_char2

end_of_string2: 
ret

decrypt endp




end
