	processor 6502
	include vcs.h

	org $F000
       
LineTick = $80
PlayerX = $81
PlayerY = $82
PlayerY1 = $83
PlayerY2 = $84

Start
	SEI  ; Disable interrupts, if there are any.
	CLD  ; Clear BCD math bit.
	LDX  #$FF
	TXS  ; Transfer X to Stack pt
	LDA #0

B1  
	STA 0,X
	DEX
	BNE B1
;*********************** GAME INIT
	LDA #246
	STA PlayerX
	STA PlayerY1
	LDA #238
	STA PlayerY2
	LDA #04
	STA LineTick

;*********************** Main Loop
MainLoop

;*********************** VERTICAL BLANK HANDLER
	LDA #2
	STA WSYNC  
	STA WSYNC
	STA WSYNC
	STA VSYNC ;Begin vertical sync.
	STA WSYNC ; First line of VSYNC
	STA WSYNC ; Second line of VSYNC.

	LDA #44
	STA TIM64T
	STA COLUPF    
	LDA #05
	STA COLUP0

	LDA #0
	STA CXCLR
	LDA #1
	STA CTRLPF

	STA  WSYNC ; Third line of VSYNC.
	STA  VSYNC ; (0)

;*************************** CONSOLE SWITCH HANDLER

;******************************* GAME CALCULATION ROUTINES

;**************************** SCREEN DRAWING ROUTINES
DrawScreen 
	LDA INTIM
	BNE DrawScreen ; Whew!
	STA WSYNC
	STA VBLANK  ;End the VBLANK period with a zero.

	LDA #00
	STA COLUBK  ; Background will be black.
	
	LDY	#04
	STY LineTick
	LDX	#48    ;
	STA WSYNC 

;******************************* SCANNING LOOP
ScanLoop
	LDA #%00000000
	STA GRP0
	STA RESP0
	STA WSYNC 
	LDA LVLX_Data0,X 
	STA PF0       
	LDA LVLX_Data1,X 
	STA PF1       
	LDA LVLX_Data2,X 
	STA PF2       
	JSR DoLine
	STA GRP0
 	LDA #$0
	STA RESP0
	STA WSYNC			;Premiere  ligne est completement waster inque pour placer le PF
	STA WSYNC			;Premiere  ligne est completement waster inque pour placer le PF
	DEX	
	BNE ScanLoop

	LDA #2
	LDY #0
	STA WSYNC  ;Finish this scanline.
	STA VBLANK ; Make TIA output invisible,
	STY PF0
	STY PF1
	STY PF1
	STY GRP0
	STY GRP1
	STY ENAM0
	STY ENAM1
	STY ENABL

;***************************** OVERSCAN CALCULATIONS
	LDX #30
KillLines
	STA WSYNC
	DEX
	BNE KillLines
	JMP  MainLoop      ;Continue forever.

DoLine ; subroutine
	STA WSYNC			;Premiere  ligne est completement waster inque pour placer le PF
	DEC PlayerY1
	LDA #%11010000
	RTS


; *********************** GRAPHICS DATA	
	org $F800 
	include Level1.a26

PFLColor ; Left side of screen
			.byte $10    ;    PADDING        
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10
			.byte $10


Player
	.byte $45
	.byte $7F
	.byte $CF
	.byte $EF
	.byte $F0
	.byte $F2
	.byte $65
	.byte $10

	org $FFFC
	.word Start
	.word Start


;**************************OLDD CODEE TO KEEEPP ************************
; ScanLoop
;	STA WSYNC 
;	NOP
;	NOP
;	NOP
;	NOP
;	NOP
;	NOP
;	NOP
;	NOP
;	NOP
;	NOP
;	NOP
;	NOP
;	NOP
;	NOP
;	NOP
;	NOP
;	NOP
;	NOP
;	NOP
;	NOP
;	NOP
;	NOP
;	NOP
;	NOP
;	NOP
;	NOP
;	NOP
;	NOP
;	NOP
;	NOP
;	DEC LineTick
;	BNE ScanLoop
;	LDA #04
;	STA	LineTick
;	LDA LVLX_Data0,X 
;	STA PF0       
;	LDA LVLX_Data1,X 
;	STA PF1       
;	LDA LVLX_Data2,X 
;	STA PF2       
;	DEX	
;	BNE ScanLoop


;Do
;	LDA LVLX_Data0,X 
;	STA PF0
;	LDA LVLX_Data1,X 
;	STA PF1       
;	LDA LVLX_Data2,X 
;	STA PF2       
;	LDA	#04
;	STA LineTick
;	DEX	
;	BEQ End
;Tantque
;	STA WSYNC 
;   lda #$FF
;    sta GRP0
;	DEC LineTick
;	BNE Tantque
;	BEQ   Do
;End

;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;