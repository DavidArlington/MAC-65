100 ;
110 ; GENERAL PURPOSE MACROS
130 ;
140 ; SETCOLOR COLOR REG, HUE, LUMINANCE
150 ;
160  .MACRO SETCOLOR
170  .IF %0<>3
180  .ERROR "SETCOLOR: Wrong # of params"
190  .ELSE
200  LDA # <%2*16
210  ORA # <%3
220  LDX # <%1
230  STA COLOR0,X ; Color reg. 0 indexed
240  .ENDIF
250  .ENDM
260 ;
270 ; ASSIGNWORD Assign value to 2 byte address
280 ;
290  .MACRO ASSIGNWORD
300  .IF %0<>2
310  .ERROR "ASSIGNWORD: 2 params required"
320  .ELSE
330  LDA # <%1
340  STA %2
350  LDA # >%1
360  STA %2+1
370  .ENDIF
380  .ENDM
390 ;