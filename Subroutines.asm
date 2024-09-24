100 ;
110 ; GENERAL PURPOSE SUBROUTINES
120 ;
130 SETCLR
140  LDA HUE
150  ASL A
160  ASL A 
170  ASL A 
180  ASL A
190  ORA LUMNCE
200  STA COLOR0,X
210  RTS
220 ;
230 PLOTCH STX COLCRS
240  STY ROWCRS
250  LDA #$60    ; Channel 6
260  LDA #$0B    ; PUTCHR IOCB Command
270  STA ICCOM,X
280  LDA #$00    ; Special PUTCHR buf len
290  STA ICBAL,X
300  STA ICBAH,X
310  STA COLOR
320  JSR CIOV
330  RTS
340 ;
350  .IF .DEF SRCADR  ;Only assemble if this label is defined
360 MOVMEM LDX SIZE+1 ;How many pages to copy
370  BEQ MVRMDR       ;zero pages to copy, move remainder
380  LDY #$00         ;Initialize Y reg to 0
390 ;
400 MVPAGE LDA (SRCADR),Y ;Copy a whole page
410  STA (DSTADR),Y
420  INY
430  BNE MVPAGE           ;whole page not done?
440  INC SRCADR+1         ;256 bytes copied, increase high
450  INC DSTADR+1         ;byte for source and dest
460  DEX                  ;reduce # of pages to copy by 1
470  BNE MVPAGE           ;more full pages to copy
480 ;
490 MVRMDR LDA SIZE       ;copy remainder < 1 page
500  BEQ DONE             ;none left? done!
510  LDY #$00             ;Initialize Y reg
520 MOVE LDA (SRCADR),Y
530  STA (DSTADR),Y
540  INY
550  CPY SIZE             ;did we get them all?
560  BEQ MVDONE           ;yes, done!
570  JMP MOVE             ;go back, get rest
580 ;
590 MVDONE RTS
600  .ENDIF               ;end conditional assembly
610 ; 