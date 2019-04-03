; #########################################################################
;
;   stars.asm - Assembly file for EECS205 Assignment 1
;
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

;; NAME: Zain Bashey

include stars.inc

.DATA

	;; If you need to, you can place global variables here

.CODE

DrawStarField proc

	;; Place your code here
      invoke DrawStar, 3, 5      ;; Star 1
      invoke DrawStar, 17, 38    ;; Star 2
      invoke DrawStar, 69, 69    ;; Star 3
      invoke DrawStar, 69, 420   ;; Star 4
      invoke DrawStar, 420, 420  ;; Star 5
      invoke DrawStar, 80, 160   ;; Star 6
      invoke DrawStar, 99, 199   ;; Star 7
      invoke DrawStar, 42, 69    ;; Star 8
      invoke DrawStar, 100, 100  ;; Star 9
      invoke DrawStar, 300, 400  ;; Star 10
      invoke DrawStar, 200, 200  ;; Star 11
      invoke DrawStar, 150, 150  ;; Star 12
      invoke DrawStar, 69, 169   ;; Star 13
      invoke DrawStar, 69, 259   ;; Star 14
      invoke DrawStar, 88, 199   ;; Star 15
      invoke DrawStar, 132, 132  ;; Star 16
	ret  			; Careful! Don't remove this line
DrawStarField endp



END
