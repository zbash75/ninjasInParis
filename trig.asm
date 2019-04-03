; #########################################################################
;
;   trig.asm - Assembly file for EECS205 Assignment 3
;
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include trig.inc
;; NAME: Zain Bashey

.DATA

;;  These are some useful constants (fixed point values that correspond to important angles)
PI_HALF = 102943           	;;  PI / 2
PI =  205887	                ;;  PI 
TWO_PI	= 411774                ;;  2 * PI 
PI_INC_RECIP =  5340353        	;;  Use reciprocal to find the table entry for a given angle
	                        ;;              (It is easier to use than divison would be)


	;; If you need to, you can place global variables here
	
.CODE

FixedSin PROC USES esi edi ebx edx angle:FXPT

      mov esi, angle      

negVals: 
                ;; Angle < 0
                ;; Keep adding by 2PI until over 0
      cmp esi, 0
      jge posVals
      add esi, TWO_PI
      jmp negVals

posVals:
                ;; Angle >= 2PI
                ;; Keep subtracting by 2PI until under 2PI
      cmp esi, TWO_PI
      jl firstCheck
      sub esi, TWO_PI
      jmp posVals

firstCheck:
      cmp esi, PI_HALF
      jg pie
      jmp lessThanPiHalf

      
pie: 
      cmp esi, PI
      jg threePiesOverTwo                
                ;; For PI/2 < Angle < PI
                ;; Angle = PI - Angle
      mov ebx, PI
      sub ebx, esi
      mov esi, ebx
      jmp lessThanPiHalf

threePiesOverTwo:
                ;; PI <= Angle <= 3PI/2
      mov edi, PI
      add edi, PI_HALF
      cmp esi, edi
      jg twoPies
      sub esi, PI
      jmp negLessThanPiHalf 

twoPies:
                ;; 3PI/2 < Angle < 2PI
      mov edi, PI
      sub esi, PI
      sub edi, esi
      mov esi, edi
      jmp negLessThanPiHalf      

      
lessThanPiHalf:
      ;; 0 < angle < PI/2
      mov eax, esi

                ;; Multiply angle by PI_INC_RECIP to obtain index in SINTAB 
      mov ebx, PI_INC_RECIP
      imul ebx
      shl edx, 16
      shr edx, 16
      movzx eax, WORD PTR [SINTAB + 2*edx]
      jmp continue
                 
negLessThanPiHalf:
      mov eax, esi
      mov ebx, PI_INC_RECIP
      imul ebx
      shl edx, 16
      shr edx, 16
      movzx eax, WORD PTR [SINTAB + 2*edx]
      neg eax
                  
      
continue:
	ret			; Don't delete this line!!!
FixedSin ENDP 
	
FixedCos PROC USES esi angle:FXPT
                ;; Angle = Angle + PI/2, then call FixedSin
	mov esi, angle
      add esi, PI_HALF
      invoke FixedSin, esi    
	ret			; Don't delete this line!!!	
FixedCos ENDP	
END
