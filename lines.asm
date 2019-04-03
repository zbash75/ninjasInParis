; #########################################################################
;
;   lines.asm - Assembly file for EECS205 Assignment 2
;
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include stars.inc
include lines.inc

.DATA

	;; If you need to, you can place global variables here
	
.CODE
	
;; NAME: Zain Bashey

;; Don't forget to add the USES the directive here
;;   Place any registers that you modify (either explicitly or implicitly)
;;   into the USES list so that caller's values can be preserved
	
;;   For example, if your procedure uses only the eax and ebx registers
;;      DrawLine PROC USES eax ebx x0:DWORD, y0:DWORD, x1:DWORD, y1:DWORD, color:DWORD
DrawLine PROC USES esi edi edx eax ebx ecx x0:DWORD, y0:DWORD, x1:DWORD, y1:DWORD, color:DWORD
	;; Feel free to use local variables...declare them here
	;; For example:
	;; 	LOCAL foo:DWORD, bar:DWORD
	      LOCAL del_x:DWORD, del_y:DWORD, x_inc:DWORD, y_inc:DWORD, error:DWORD
	;; Place your code here

      ;; Finds the difference between x1 and x0
      mov esi, x1
      sub esi, x0

      ;; Find absolute value by negating value if it is negative, and then puts into del_x
      cmp esi, 0
      jge continue
      neg esi
continue:
      mov del_x, esi

      ;; Repeats above process but for del_y
      mov esi, y1
      sub esi, y0
      cmp esi, 0
      jge continuetwo
      neg esi
continuetwo:
      mov del_y, esi

      ;; Checks if x0 is less than x1 and sets the x-increment appropriately
      mov ebx, x0
      mov ecx, y0
      cmp ebx, x1
      jge negx
      mov x_inc, 1
      jmp continuethree
negx:
      mov x_inc, -1
continuethree:
      ;; Repeats above process for y0 and y1
      cmp ecx, y1 
      jge negy
      mov y_inc, 1
      jmp nextpart
negy:
      mov y_inc, -1
nextpart:
      mov esi, 2
      mov eax, del_x
      cmp eax, del_y
      jle elsecase

      ;; If del_x greater than del_y, divide del_x by 2 and store in error
      xor edx, edx
      div esi
      mov error, eax
elsecase:
      ;; If del_x less than or equal to del_y, divide del_y by 2, store in error, and negate the result
      xor edx, edx
      mov eax, del_y
      div esi
      mov error, eax
      neg error

      ;; Negates del_x for later comparison
      mov edi, del_x
      neg edi
      mov esi, error

      ;; Calls DrawPixel with arguments ebx, ecx, and color
      invoke DrawPixel, ebx, ecx, color

      ;; Compares ebx and x1 then ecx and y1 to determine whether to enter while loop
      cmp ebx, x1
      jne whileloop
      cmp ecx, y1
      je continuefour
whileloop:
      ;; Calls DrawPixel with arguments ebx, ecx, and color
      invoke DrawPixel, ebx, ecx, color
      mov edx, esi

      ;; Compares edx and edi to determine whether to implement body of first if statement
      cmp edx, edi
      jle first

      ;; Updates values of esi and ebx
      sub esi, del_y
      add ebx, x_inc
first:
      ;; Compares edx and del_y to determine whether to implement body of second if statement
      cmp edx, del_y
      jge second

      ;; Updates values of esi and ecx
      add esi, del_x
      add ecx, y_inc
second:
      ;; Determines whether to repeat or exit while loop
      cmp ebx, x1
      jne whileloop
      cmp ecx, y1
      jne whileloop
continuefour:
	ret        	;;  Don't delete this line...you need it
DrawLine ENDP




END
