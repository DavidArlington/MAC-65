100  .TITLE "Dog Park Demo Part 1"
110  .OPTOBJ
115  .INCLUDE #D2:MACROS.M65
120 ;
130 ; General System Equates
140 ;
150 STICK0 = $0278
160 STRIG0 = $0284
170 CONSOL = $D01F
180 RTCLOK = $14
190 COLOR0 = $02C4
200 COLCRS = $55
210 ROWCRS = $54
220 CHBAS  = $02F4
230 MEMTOP = $02E5
240 ;
250 ; Program Variables
260 ;
270  *= $D4
280 ;
290 COLOR .DS 1
320 ;
330 DOG .DS 1
340 SRCADR .DS 2
350 DSTADR .DS 2
360 SIZE .DS 2
370 RAMSET .DS 2
380 ;
390 CURX .DS 1
400 CURY .DS 1
410 OLDX .DS 1
420 OLDY .DS 1
430 STKPOS .DS 1
440 ;
450 ; IOCB System Equates
460 ;
470 CIOV = $E456
480 ;
490 ICCOM = $0342
500 ICBAL = $0344
510 ICBAH = $0345
520 ICAX1 = $034A
530 ICAX2 = $034B
540 ;
550  *= $4000
560 ;
570 ; Main Logic
580 ;
590 BEGIN JSR SETUP
600 LOOP LDA CURX    ;copy cur x/y to old x/y
610  STA OLDX
620  LDA CURY
630  STA OLDY
640  JSR CHKMVE      ;did stick move?
650  LDA OLDX
660  CMP CURX
670  BNE MOVEDG      ;x pos changed, move Dog
680  LDA OLDY
690  STA OLDY
700  BNE MOVEDG      ;y pos changed, move Dog
710  JMP CHKEXT      ;no move, check exit
720 MOVEDG JSR DELAY ;Slow down for humans
730  JSR DRAWDG      ;erase dog in old, draw in new  
740  JMP CHKEXT      ;check for exit
750 ;
760  .INCLUDE #D2:DPPART2.M65
770 ;
780  .INCLUDE #D2:SUBROUTN.M65
790 ;
800 ; Program data and constants
810 ;
820 DOGRGT .BYTE $3E
830 DOGLFT .BYTE $3C
840 BLANK .BYTE $20
850 MINX .BYTE $00
860 MINY .BYTE $00
870 MAXX .BYTE $13
880 MAXY .BYTE $17
890 PAUZE .BYTE $04
900 OPEN .BYTE $03
910 CLOSE .BYTE $0C
920 ;
930 DOGSHPS .BYTE $10,$60,$FF,$3E,$26,$25,$49,$00
940  .BYTE $00,$00,$00,$00,$00,$00,$00,$00
950  .BYTE $08,$06,$FF,$7C,$64,$A4,$92,$00
960 ;
970 SCREEN .BYTE "S:",$9B
980 ;
990  *= $02E0
1000  .WORD BEGIN
1010 ;