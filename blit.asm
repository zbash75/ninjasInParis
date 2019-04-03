; #########################################################################
;
;   blit.asm - Assembly file for EECS205 Assignment 3
;
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include stars.inc
include lines.inc
include trig.inc
include blit.inc

;; NAME: Zain Bashey

.DATA

	;; If you need to, you can place global variables here
	
.CODE

DrawPixel PROC USES edi ecx x:DWORD, y:DWORD, color:DWORD
                    ;; If coordinate out of bounds, don't draw
      cmp x, 639
      jg continue
      cmp x, 0
      jl continue
      cmp y, 479
      jg continue
      cmp y, 0
      jl continue

                    ;; address = screenBitsPtr + x + 640*y
      mov edi, y
      imul edi, 640
      add edi, x
      add edi, ScreenBitsPtr
      mov ecx, color
      mov BYTE PTR[edi], cl
continue:
	ret 			; Don't delete this line!!!
DrawPixel ENDP

BasicBlit PROC USES esi edx ecx edi ebx ptrBitmap:PTR EECS205BITMAP , xcenter:DWORD, ycenter:DWORD
      LOCAL xCurr:DWORD, yCurr:DWORD, xStart:DWORD, xNum:DWORD, yNum:DWORD, transparent:BYTE
      
      mov esi, ptrBitmap

                ;; set xCurr to xcenter - xCurr/2
      mov edx, xcenter
      mov xCurr, edx
      mov edx, (EECS205BITMAP PTR [esi]).dwWidth
      sar edx, 1
      sub xCurr, edx

                ;; set yCurr to ycenter - yCurr/2
      mov edx, ycenter
      mov yCurr, edx
      mov edx, (EECS205BITMAP PTR [esi]).dwHeight
      sar edx, 1
      sub yCurr, edx

                ;; store bTransparent and lpBytes in local variable and register
      xor ebx, ebx
      mov bl, (EECS205BITMAP PTR [esi]).bTransparent
      mov transparent, bl
      mov edi, (EECS205BITMAP PTR [esi]).lpBytes

                ;; give yNum and xNum inital loop values of 0
      mov yNum, 0
      mov xNum, 0

                ;; if yNum >= dwHeight, exit function
      mov ecx, yNum
      cmp ecx, (EECS205BITMAP PTR [esi]).dwHeight
      jge finish
      
inner_loop:
                ;; if xNum >= dwWidth, jump to outer loop
      mov ecx, xNum
      cmp ecx, (EECS205BITMAP PTR [esi]).dwWidth
      jge outer_loop

                ;; access current address: yNum*dwWidth + xNum + lpBytes     
      mov eax, (EECS205BITMAP PTR [esi]).dwWidth
      imul yNum
      add eax, xNum
      xor edx, edx
      mov dl, BYTE PTR[edi + eax]

      mov ecx, xNum
      add ecx, xCurr
      mov ebx, yNum
      add ebx, yCurr

                ;; If current coordinates outside of bitmap, do not draw
      cmp ecx, 0
      jl continue
      cmp ecx, 639
      jg continue
      cmp ebx, 0
      jl continue
      cmp ebx, 479
      jg continue
      
                ;; If transparent, do not draw
      cmp dl, transparent
      je continue
      invoke DrawPixel, ecx, ebx, dl
      
continue:
                ;; Increment xNum and repeat inner loop
      inc xNum
      jmp inner_loop

outer_loop:
                ;; Increment yNum and if >= dwHeight, exit loop and end function
      inc yNum
      mov ecx, yNum
      cmp ecx, (EECS205BITMAP PTR [esi]).dwHeight
      jge finish

                ;; If not, set xNum to 0 and restart outer loop
      mov xNum, 0
      jmp inner_loop

finish:      
	ret 			; Don't delete this line!!!	
BasicBlit ENDP


RotateBlit PROC USES esi ebx ecx edx lpBmp:PTR EECS205BITMAP, xcenter:DWORD, ycenter:DWORD, angle:FXPT
      LOCAL cosa:FXPT, sina:FXPT, shiftX:FXPT, shiftY:FXPT, dstHeight:DWORD, dstWidth:DWORD, dstX:DWORD, dstY:DWORD, srcX:FXPT, srcY:FXPT, x_input:DWORD, y_input:DWORD
                ;; cosa = FixedCos(angle), sina = FixedSin(angle) 
      invoke FixedCos, angle
      mov cosa, eax
      invoke FixedSin, angle
      mov sina, eax

      mov esi, lpBmp

                ;; shiftX = dwWidth*cosa/2 - dwHeight*sina/2
      mov ebx, cosa
      shr ebx, 1
      mov ecx, sina
      shr ecx, 1
      
      mov eax, (EECS205BITMAP PTR [esi]).dwHeight
      shl eax, 16
      imul ebx
      shl edx, 16
      shr eax, 16
      or eax, edx
      sar eax, 16
      mov shiftY, eax

      mov eax, (EECS205BITMAP PTR [esi]).dwWidth
      shl eax, 16
      imul ecx
      shl edx, 16
      shr eax, 16
      or eax, edx
      sar eax, 16
      sub shiftX, eax

                ;; shiftY = dwHeight*cosa/2 + dwWidth*sina/2
      mov ebx, cosa
      shr ebx, 1
      mov ecx, sina
      shr ecx, 1
      mov eax, (EECS205BITMAP PTR [esi]).dwHeight
      shl eax, 16
      imul ebx
      shl edx, 16
      shr eax, 16
      or eax, edx
      sar eax, 16
      mov shiftY, eax

      mov eax, (EECS205BITMAP PTR [esi]).dwWidth
      shl eax, 16
      imul ecx
      shl edx, 16
      shr eax, 16
      or eax, edx
      sar eax, 16
      add shiftY, eax

                ;; dstHeight = dstWidth = dwWidth + dwHeight
      mov eax, (EECS205BITMAP PTR [esi]).dwWidth
      add eax, (EECS205BITMAP PTR [esi]).dwHeight
      mov dstHeight, eax
      mov dstWidth, eax

                ;; dstX = dstY = -dstWidth = -dstHeight
      neg eax
      mov dstX, eax

outer_loop:
                ;; if dstX > dstWidth, exit outer loop and end function
      mov eax, dstX
      cmp eax, dstWidth
      jge finished
      mov eax, dstHeight
      neg eax
      mov dstY, eax
      jmp inner_loop
      
outer_cond:
                ;; when inner loop finishes, update dstX and jump to outer loop
      inc dstX 
      jmp outer_loop
      
inner_loop:
                ;; if dstY > dstHeight, exit inner loop and jump to outer_cond
      mov eax, dstY
      cmp eax, dstHeight
      jge outer_cond

                ;; srcX = dstX*cosa + dstY*sina 
      mov eax, dstX
      shl eax, 16
      mov ebx, cosa
      imul ebx
      shl edx, 16
      shr eax, 16
      or eax, edx
      sar eax, 16
      mov srcX, eax
      mov eax, dstY
      shl eax, 16
      mov ebx, sina
      imul ebx
      shl edx, 16
      shr eax, 16
      or eax, edx
      sar eax, 16
      add srcX, eax

                ;; srcY = dstY*cosa - dstX*sina
      mov eax, dstY
      shl eax, 16
      mov ebx, cosa
      imul ebx
      shl edx, 16
      shr eax, 16
      or eax, edx
      sar eax, 16
      mov srcY, eax
      mov eax, dstX
      shl eax, 16
      mov ebx, sina
      imul ebx
      shl edx, 16
      shr eax, 16
      or eax, edx
      sar eax, 16
      sub srcY, eax

                ;; srcX >= 0
      cmp srcX, 0
      jl inner_inc
      
                ;; srcX < dwWidth
      mov eax, (EECS205BITMAP PTR [esi]).dwWidth
      cmp srcX, eax
      jge inner_inc

                ;; srcY >= 0      
      cmp srcY, 0
      jl inner_inc

                ;; srcY < dwHeight
      mov eax, (EECS205BITMAP PTR [esi]).dwHeight
      cmp srcY, eax
      jge inner_inc

                ;; (xcenter+dstX-shiftX) >= 0 & (xcenter+dstX-shiftX) < 639
      mov eax, xcenter
      add eax, dstX
      sub eax, shiftX
      mov x_input, eax
      cmp x_input, 0
      jl inner_inc
      cmp x_input, 639
      jge inner_inc

                ;; (ycenter+dstY-shiftY) >= 0 & (ycenter+dstY-shiftY) < 479
      mov eax, ycenter
      add eax, dstY
      sub eax, shiftY
      mov y_input, eax
      cmp y_input, 0
      jl inner_inc
      cmp y_input, 479
      jge inner_inc

                ;; bitmap pixel (srcX, srcY) is not transparent
      mov eax, srcY
      mov ebx, (EECS205BITMAP PTR [esi]).dwWidth
      imul ebx
      add eax, srcX
      add eax, (EECS205BITMAP PTR [esi]).lpBytes
      movzx edx, BYTE PTR [eax]
      cmp dl, (EECS205BITMAP PTR [esi]).bTransparent
      je inner_inc

      invoke DrawPixel, x_input, y_input, dl

inner_inc:
                ;; increment dstY and repeat inner loop
      inc dstY
      jmp inner_loop

finished:
	ret 			; Don't delete this line!!!		
RotateBlit ENDP



END
