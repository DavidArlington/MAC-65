1190 ;
2000 ; SETUP LOGIC
2010 ;
2020 SETUP LDX #$60   ;Channel 6
2030  LDA CLOSE       ;Close Screen first
2040  STA ICCOM,X 
2050  JSR CIOV
2060 ;
2070  LDX #$60        ;Channel 6
2080  LDA OPEN        ;Open Screen
2090  STA ICCOM,X
2100  LDA # <SCREEN   ;Address of "S:" string
2110  STA ICBAL,X    
2120  LDA # >SCREEN
2130  STA ICBAH,X 
2140  LDA #$01        ;Graphics 1
2150  STA ICAX2,X 
2160  LDA #$0C        ;Read/Write mode
2170  STA ICAX1,X 
2180  JSR CIOV
2190 ;
2195  JSR SETCHR
2198 ;
2200  SETCOLOR 4,12,15 ;Color reg.4, bright green background
2210 ;
2220  SETCOLOR 2,3,2   ;Color reg.2, new character brown
2260 ;
2270  SETCOLOR 0,0,0   ;Color reg.0, dog character black
2320 ;
2330  LDA DOGRGT      ;Initialize dog facing right
2340  STA DOG
2350  STA COLOR
2360  LDA #$00        ;initial x/y screen positions
2370  STA CURX
2380  STA CURY
2390  TAX             ;Setup for plot character
2400  TAY
2410  JSR PLOTCH
2420 ;
2430  RTS             ;Setup all done
2440 ;
3000 ; CHECK MOVE LOGIC
3010 ;
3020 CHKMVE LDA STICK0;Get reading from hardware
3030  STA STKPOS      ;Store in variable
3040  AND #$01        ;Stick up?
3050  BNE STKDWN      ;no, check down
3060  LDA MINY        ;else
3070  CMP CURY        ;at top of screen?
3080  BNE SUBY        ;no, subtract 1 from Y
3090  LDA MAXY        ;else
3100  STA CURY        ;set at bottom Screen
3110  JMP STKLFT      ;go check left/right
3120 SUBY DEC CURY    ;y=y-1
3130  JMP STKLFT      ;go check left/right
3140 ;
3150 STKDWN LDA STKPOS;Get stick position
3160  AND #$02        ;Stick down?
3170  BNE STKLFT      ;no, check left
3180  LDA MAXY        ;else
3190  CMP CURY        ;at bottom of screen?
3200  BNE ADDY        ;no, add 1 to Y
3210  LDA MINY        ;else
3220  STA CURY        ;set at top Screen
3230  JMP STKLFT      ;go check left/right
3240 ADDY INC CURY    ;y=y+1
3250 ;
3260 STKLFT LDA STKPOS;Get reading from hardware
3270  AND #$04        ;Stick left?
3280  BNE STKRGT      ;no, check right
3290  LDA DOGLFT      ;Set dog facing left
3300  STA DOG
3310  LDA MINX        ;else
3320  CMP CURX        ;at left of screen?
3330  BNE SUBX        ;no, subtract 1 from X
3340  LDA MAXX        ;else
3350  STA CURX        ;set at right edge
3360  JMP CHKOVR      ;checks all done
3370 SUBX DEC CURX    ;x=x-1
3380  JMP CHKOVR      
3390 ;
3400 STKRGT LDA STKPOS;Get stick position
3410  AND #$08        ;Stick right?
3420  BNE CHKOVR      ;no, checks done
3430  LDA DOGRGT      ;Set dog facing right
3440  STA DOG
3450  LDA MAXX        ;else
3460  CMP CURX        ;at right of screen?
3470  BNE ADDX        ;no, add 1 to X
3480  LDA MINX        ;else
3490  STA CURX        ;set at left of Screen
3500  JMP CHKOVR
3510 ADDX INC CURX    ;x=x+1
3520 CHKOVR RTS       ;Checks are done!
3530 ;
4000 ; DRAW CHARACTERS, CHECK FOR EXIT,
4010 ; AND DELAY LOGIC
4020 ;
4030 DRAWDG LDA BLANK ;blank out old position
4040  STA COLOR
4050  LDX OLDX
4060  LDY OLDY
4070  JST PLOTCH
4080 ;
4090  LDA DOG         ;plot dog char at nrew
4100  STA COLOR
4110  LDX CURX
4120  LDY CURY
4130  JSR PLOTCH
4140 ;
4150  RTS
4160 ;
4200 DELAY LDA #$00   ;zero out RTCLOK
4210  STA RTCLOK
4220 DLOOP LDA RTCLOK ;delay LOOP
4230  CMP PAUZE       ;RTCLOK >= PAUZE?
4240  BCS DONE        ;yes, exit LOOP
4250  JMP DLOOP       ;else still waiting
4260 DONE RTS
4270 ;
4300 CHKEXT LDA STRIG0
4310  BEQ END         ;trigger pressed? exit
4320  LDA CONSOL
4330  CMP #$06        ;START pressed?
4340  BEQ END         ;yes, then exit
4350  JMP LOOP        ;else jump to main loop
4360 END RTS          ;Program over!
4370 ;
4380 ; SETCHR - Define Dog Characters in RAM char set
4390 ;
4400 SETCHR
4410  LDA MEMTOP+1    ;get hi byte of current MEMTOP
4420  SBC #$02        ;lower by 2 pages
4430  AND #$FE        ;For GR.1 need an even page number
4440  STA MEMTOP+1    ;reset MEMTOP to our new lower Addr
4450  STA RAMSET+1    ;Our RAM char set goes here too
4460  LDA #$00        ;Zero out low bytes for a page addr
4470  STA MEMTOP
4480  STA RAMSET
4490 ;
4500  LDA RAMSET      ;New RAMSET is the destination addr
4510  STA DSTADR
4520  LDA RAMSET+1
4530  STA DSTADR+1
4540 ;
4550  ASSIGNWORD $E000,SRCADR  ;ROM Char set at $E000 is our source
4590 ;
4600  ASSIGNWORD $0200,SIZE    ;size we want to copy is 2 pages
640 ;
4650  JSR MOVMEM      ;copy the 2 pages to our RAMSET!
4660 ;
4670  LDA #[$1C*$08]  ;the destination for our redefined
4680  STA DSTADR      ;dog shapes is 28 chars * 8 bytes
4690  LDA RAMSET+1    ;into our RAMSET = $1C * $08
4700  STA DSTADR+1    ;high byte is RAMSET high byte
4710 ;
4720  ASSIGNWORD DGSHPS,SRCADR ;Address of dog shapes to copy
4760 ;
4770  ASSIGNWORD $18,SIZE ;size is 24 bytes of dog data
4810 ;
4820  JSR MOVMEM      ;copy dog shapes to our RAMSET
4830 ;
4840  LDA RAMSET+1    ;finally, tell computer where to
4850  STA CHBAS       ;find our new redefined char set
4860 ;
4870  RTS
4880 ;
