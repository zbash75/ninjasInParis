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

yeezys EECS205BITMAP <49, 35, 0ffh,, offset yeezys + sizeof yeezys>
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0dbh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,092h,06dh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,049h,049h,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0dbh,06dh,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fbh,091h,049h,024h,024h
	BYTE 0b6h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0b6h,092h,092h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,049h,049h,049h
	BYTE 024h,049h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0dbh,092h,06dh,092h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fbh,06dh,049h,049h
	BYTE 048h,049h,049h,0b6h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0dbh,06dh,06dh,06dh,0dbh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,049h,06dh
	BYTE 06dh,049h,044h,024h,000h,06dh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,092h,06dh,092h,08dh,0ffh,0ffh,0ffh,0ffh,0ffh,0fbh,06dh,049h
	BYTE 049h,06dh,049h,049h,024h,024h,049h,0b6h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,06dh,092h,092h,092h,092h,0dbh,0ffh,0ffh,0dbh,092h,06dh
	BYTE 08dh,06dh,06dh,049h,049h,049h,049h,024h,000h,092h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0fbh,06dh,08dh,08dh,08dh,08dh,08dh,091h,092h,091h,08dh
	BYTE 091h,08dh,08dh,092h,06dh,06dh,069h,048h,024h,024h,049h,0ffh,0fbh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0f6h,0d1h,0d1h,0cdh,0cdh,0adh,089h,088h,068h,069h
	BYTE 069h,08dh,08dh,08dh,08dh,08dh,08dh,069h,048h,069h,049h,069h,044h,024h,044h,0fbh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fah,0d1h,0d1h,0f1h,0cdh,0cdh,0cdh,0cdh,0adh,08dh
	BYTE 08dh,08dh,08dh,08dh,08dh,08dh,08dh,08dh,089h,089h,089h,089h,069h,064h,064h,044h
	BYTE 08dh,092h,0d6h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0d6h,0b1h,0adh,0d1h,0cdh,0cdh,0cdh,0cdh,0cdh,0adh
	BYTE 0adh,0cdh,0cdh,0cdh,0cdh,0cdh,0cdh,0adh,0adh,0adh,0adh,0adh,0adh,089h,089h,089h
	BYTE 088h,064h,044h,048h,08dh,0b2h,0fbh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fbh,091h,0b1h,0b2h,0adh,0adh,0adh,0adh,0adh,0adh
	BYTE 0adh,0adh,0adh,0cdh,0cdh,0cdh,0cdh,0cdh,0cdh,0adh,0adh,0adh,0a9h,0cdh,0adh,0adh
	BYTE 0adh,0cdh,0a8h,088h,089h,088h,068h,068h,068h,08dh,0b1h,0b2h,0dah,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,091h,091h,092h,0b2h,0b2h,0b1h,0b1h,0adh,0adh
	BYTE 0adh,0adh,0adh,0adh,0adh,0adh,0adh,0adh,0adh,0adh,0adh,0adh,0adh,0adh,0cdh,0cdh
	BYTE 0cdh,0adh,0cdh,0cdh,0a9h,0cdh,0cdh,0cdh,0cdh,0adh,0adh,089h,089h,069h,08dh,092h
	BYTE 0d6h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0dbh,06dh,06dh,06dh,091h,091h,092h,092h,091h
	BYTE 091h,0b1h,0b2h,0b2h,0b2h,0b1h,0b1h,0b1h,0adh,0adh,0adh,0adh,0adh,0adh,0adh,0adh
	BYTE 0adh,0adh,0adh,0adh,0adh,0a9h,0a9h,0a9h,0a9h,0adh,0adh,0adh,08dh,08dh,089h,069h
	BYTE 049h,049h,049h,092h,0ffh,0ffh,0ffh,0ffh,092h,0b6h,092h,092h,092h,071h,06dh,06dh
	BYTE 06dh,06dh,06dh,069h,08dh,08dh,08dh,091h,092h,091h,08dh,08dh,08dh,08dh,08dh,08dh
	BYTE 08dh,08dh,0adh,08dh,08dh,08dh,08dh,08dh,089h,08dh,08dh,08dh,08dh,06dh,069h,069h
	BYTE 069h,049h,049h,024h,024h,0b6h,0ffh,0ffh,0b6h,0b6h,0b6h,0b6h,0b6h,092h,0b6h,092h
	BYTE 092h,092h,092h,08dh,06dh,06dh,069h,069h,069h,06dh,08dh,08dh,08dh,08dh,08dh,08dh
	BYTE 06dh,08dh,08dh,08dh,08dh,08dh,08dh,06dh,08dh,06dh,06dh,06dh,069h,069h,049h,049h
	BYTE 049h,049h,024h,049h,049h,024h,06dh,0ffh,0fbh,0b2h,0b6h,0b6h,0b6h,0b2h,0b6h,092h
	BYTE 0b6h,0b2h,092h,092h,0b2h,0b2h,0b2h,0b2h,091h,091h,08dh,08dh,06dh,06dh,069h,069h
	BYTE 069h,069h,06dh,06dh,069h,069h,069h,06dh,049h,049h,049h,049h,049h,049h,049h,049h
	BYTE 049h,049h,049h,024h,049h,049h,049h,08dh,0ffh,0dah,0b6h,0b6h,0b6h,0b6h,0b6h,0d6h
	BYTE 0b2h,0b6h,0b6h,0b2h,0b2h,0b2h,0b2h,092h,092h,092h,092h,092h,092h,092h,092h,092h
	BYTE 092h,091h,091h,091h,06dh,06dh,06dh,06dh,06dh,06dh,04dh,06dh,06dh,06dh,06dh,06dh
	BYTE 06dh,06dh,06dh,06dh,08dh,08dh,06dh,06dh,0b6h,0ffh,0b6h,096h,0b6h,0d6h,0b6h,0b2h
	BYTE 0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,096h,092h,092h,092h,096h,096h,096h,096h,096h
	BYTE 0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,0b2h,0b2h,0b2h,0b2h
	BYTE 0b2h,0b2h,092h,092h,092h,06dh,06dh,06dh,0b6h,0ffh,0ffh,0dbh,096h,092h,0b6h,0b6h
	BYTE 0b2h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,096h,096h,096h,096h,096h,0b6h,0b6h,0b6h
	BYTE 0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h,0b6h
	BYTE 092h,092h,092h,06dh,06dh,092h,092h,0dah,0ffh,0ffh,0ffh,0ffh,0ffh,0dbh,092h,06dh
	BYTE 06dh,06dh,06dh,06dh,06dh,06dh,06dh,06dh,071h,071h,071h,06dh,08dh,08dh,08eh,092h
	BYTE 092h,092h,092h,092h,092h,092h,092h,092h,0b6h,092h,092h,092h,092h,092h,091h,06dh
	BYTE 06dh,049h,049h,049h,06dh,08dh,0b6h,0dbh,0dbh,0fbh,0ffh,0ffh,0ffh,0ffh,0ffh,0dbh
	BYTE 0b6h,092h,08dh,092h,08dh,06dh,06dh,06dh,06dh,06dh,06dh,06dh,06dh,08dh,08dh,08dh
	BYTE 08eh,08eh,08eh,08eh,092h,08dh,06dh,06dh,06dh,06dh,06dh,06dh,06dh,06dh,04dh,04dh
	BYTE 04dh,06dh,06dh,092h,092h,0b6h,0d6h,0dbh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh
END
