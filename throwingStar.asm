      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include stars.inc
include lines.inc
include trig.inc
include blit.inc
include game.inc

;; Has keycodes
include keys.inc

.DATA

throwingStar EECS205BITMAP <25, 25, 0ffh,, offset throwingStar + sizeof throwingStar>
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0dbh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0dbh,092h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0dbh,049h,06dh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0dbh,092h,049h,0b6h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,06dh,06dh,0b6h
	BYTE 0dbh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0dbh,049h,0b6h,0ffh,0dbh,0ffh,0dbh,0b6h,092h,06dh,06dh
	BYTE 06dh,06dh,092h,0dbh,0dbh,0ffh,0ffh,0dbh,0dbh,0ffh,0ffh,0ffh,0ffh,0ffh,092h,024h
	BYTE 0dbh,0dbh,0b6h,06dh,049h,024h,024h,06dh,092h,06dh,024h,024h,092h,0b6h,0ffh,0ffh
	BYTE 0dbh,06dh,092h,0ffh,0ffh,0ffh,0ffh,06dh,024h,0ffh,0ffh,092h,024h,024h,06dh,0dbh
	BYTE 0ffh,0dbh,092h,0dbh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,024h,06dh,0dbh,0ffh,0dbh
	BYTE 06dh,000h,0dbh,0ffh,092h,000h,092h,0ffh,0ffh,0dbh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0b6h,06dh,0b6h,0b6h,0ffh,0b6h,049h,000h,049h,06dh,024h,024h,06dh
	BYTE 0ffh,0ffh,06dh,0b6h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,092h,049h,0ffh
	BYTE 0ffh,0dbh,0ffh,092h,024h,024h,024h,024h,024h,049h,024h,000h,049h,092h,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0dbh,06dh,024h,0b6h,0ffh,0ffh,092h,024h,024h,049h
	BYTE 024h,024h,024h,049h,049h,024h,024h,092h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0dbh,06dh,024h,049h,049h,024h,024h,049h,049h,049h,024h,049h,0ffh,0ffh,0dbh,06dh
	BYTE 024h,092h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0dbh,092h,049h,024h,049h,049h
	BYTE 024h,024h,024h,024h,024h,0dbh,0ffh,0ffh,0ffh,092h,024h,0b6h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0dbh,0b6h,0b6h,0ffh,0dbh,024h,024h,049h,06dh,024h,024h,06dh
	BYTE 0dbh,0dbh,0dbh,092h,06dh,0dbh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0dbh,0ffh
	BYTE 0ffh,0dbh,024h,049h,0ffh,0ffh,092h,024h,092h,0dbh,0ffh,092h,049h,049h,0b6h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0b6h,092h,0b6h,0ffh,0ffh,092h,024h,024h,06dh,0ffh,0ffh,0b6h
	BYTE 024h,092h,0ffh,0ffh,0ffh,0dbh,049h,092h,0ffh,0ffh,0b7h,092h,049h,024h,06dh,0b6h
	BYTE 06dh,049h,025h,049h,092h,092h,0dbh,0ffh,0b6h,024h,092h,0ffh,0ffh,0ffh,0ffh,0dbh
	BYTE 092h,0dbh,0ffh,0dbh,0b6h,0b6h,0b6h,092h,06dh,092h,092h,0b6h,0dbh,0dbh,0ffh,0dbh
	BYTE 0ffh,092h,049h,0b6h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0dbh,0ffh,0ffh,0ffh,0ffh,0dbh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,0dbh,06dh,06dh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,092h,06dh,06dh,0b6h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,06dh,092h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,06dh,092h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0dbh,092h,0dbh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0dbh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh
END
