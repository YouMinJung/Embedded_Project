SELECT  EQU     0FC48H
        
        ORG     0000H
        JMP     START        
        
        ORG     001BH
        JMP     TIMER1
        
        ORG     0030H
START:  MOV     SP,#60H
        MOV     PSW,#0
        MOV     R3, #0     ;ADDRESS
        MOV     R4, #5     ;PAGE
        
        MOV     TMOD,#0A1H

        MOV     TH1,#0
        MOV     TL1,#0
        MOV     TH0,#0
        MOV     TL0,#0
        
        MOV     A,#10001111B
        MOV     DPTR,#SELECT
        MOVX    @DPTR,A

        CALL    CLEAR0
        CALL    CLEAR1

; LCD0
F1:     CALL    CLEAR0
        CALL    MARIO1
        CALL    MARIOBODY
        CALL    MARIOLEG
	CALL	COIN1
	CALL 	COIN2
	CALL	SCORE
	
        CALL    WAIT
	INC     R3
	CALL    CLEAR0 
	CALL	MARIO2
        CALL    MARIO2BODY
        CALL    MARIO2LEG
	CALL	COIN1
	CALL 	COIN2
	CALL	SCORE
	CALL	WAIT
        INC     R3
        CJNE    R3, #32, F1
        JMP     F2

F2:	CALL    CLEAR0 
	CALL	MARIO2
	CALL    MARIO2BODY
        CALL    MARIO2LEG
	CALL	COIN1
	CALL 	COIN2
	CALL	SCORE
	CALL    WAIT
	INC     R3
	DEC	R4
	CJNE    R3, #64, FF1
	

	
FF1:	
        CJNE	R4, #1, F2
        CALL    SON1
        CALL    SON2
	CALL    CLEAR0
	CALL 	CLEAR1 
	CALL	SCORE1
	MOV	R3,#0
	JMP	F3
	

; LCD1

F3:	CALL    CLEAR1
	CALL	MARIO12
	CALL    MARIO12BODY
        CALL    MARIO12LEG	
	CALL	SCORE1
	CALL    WAIT
	INC     R3
	INC	R4
	CJNE    R3, #32, FF2
FF2:	CJNE	R4, #5, F3
	JMP	F4

F4:	CALL    CLEAR1
	CALL	MARIO12
	CALL    MARIO12BODY
        CALL    MARIO12LEG
	CALL	SCORE1	
	CALL    WAIT
	INC     R3
	CALL    CLEAR1
	CALL	MARIO11
	CALL    MARIO11BODY
        CALL    MARIO11LEG
	CALL	SCORE1	
	CALL    WAIT
	INC     R3
	CJNE    R3, #46, F4
        CALL    CLEAR0
        CALL    CLEAR1
        MOV     R3, #0
        MOV     R4, #5
        JMP     F1

WAIT:	MOV     R2,#1
WAIT1:  MOV     R1,#0
WAIT2:  MOV     R0,#0
WAIT3:  NOP
        DJNZ    R0,WAIT3
        DJNZ    R1,WAIT2
        DJNZ    R2,WAIT1
        RET
        
TIMER1: INC     R5
        RETI

SON1:   MOV     R6,#24
        MOV     TH1,#0
        MOV     TL1,#0
        SETB    ET1
        SETB    TR1
        SETB    EA

LOOP8:  MOV     R5,#0
        CLR     T0

LP15:   CJNE    R5,#5,LP15
        MOV     R5,#0
        SETB    T0

LP16:   CJNE    R5,#5,LP16
        DJNZ    R6,LOOP8
        SETB    T0
        CLR     TR1
        CLR     ET1
        CLR     EA
        RET
        
SON2:   MOV     R6,#27
        MOV     TH1,#0
        MOV     TL1,#0
        SETB    ET1
        SETB    TR1
        SETB    EA

LOOP7:  MOV     R5,#0
        CLR     T0

LP13:   CJNE    R5,#7,LP13
        MOV     R5,#0
        SETB    T0

LP14:   CJNE    R5,#7,LP14
        DJNZ    R6,LOOP7
        SETB    T0
        CLR     TR1
        CLR     ET1
        CLR     EA
        RET
        


; MARIO LCD0, LCD1
MARIO1: MOV     A,R4         
        CALL    XPAGE0
        MOV     A,R3         
        CALL    ADDR0
	MOV     DPTR,#M1
	MOV     R7,#0
DISP1:  MOV     A,R7         
        MOVC    A,@A+DPTR     
        CALL    FONT0        
        INC     R7           
        CJNE    R7,#16,DISP1
        RET

MARIOBODY:      MOV     B,R4
                INC     R4
                MOV     A,R4
                CALL    XPAGE0
                MOV     A,R3
                CALL    ADDR0
	        MOV     DPTR,#M11
	        MOV     R7,#0
DISPBODY:       MOV     A,R7
                MOVC    A,@A+DPTR
                CALL    FONT0
                INC     R7
                CJNE    R7,#16,DISPBODY
                MOV     R4,B
                RET

MARIOLEG:       MOV     B,R4
                INC     R4
                INC     R4
                MOV     A,R4
                CALL    XPAGE0
                MOV     A,R3
                CALL    ADDR0
	        MOV     DPTR,#M111
	        MOV     R7,#0
DISPLEG:        MOV     A,R7
                MOVC    A,@A+DPTR
                CALL    FONT0
                INC     R7
                CJNE    R7,#16,DISPLEG
                MOV     R4, B
                RET

MARIO2: MOV     A,R4         
        CALL    XPAGE0
        MOV     A,R3        
        CALL    ADDR0
	MOV     DPTR,#M2
	MOV     R7,#0
DISP2:  MOV     A,R7         
        MOVC    A,@A+DPTR    
        CALL    FONT0        
        INC     R7           
        CJNE    R7,#16,DISP2
        RET
        
MARIO2BODY:     MOV     B,R4
                INC     R4
                MOV     A,R4
                CALL    XPAGE0
                MOV     A,R3
                CALL    ADDR0
	        MOV     DPTR,#M22
	        MOV     R7,#0
DISP2BODY:       MOV     A,R7
                MOVC    A,@A+DPTR
                CALL    FONT0
                INC     R7
                CJNE    R7,#16,DISP2BODY
                MOV     R4,B
                RET

MARIO2LEG:      MOV     B,R4
                INC     R4
                INC     R4
                MOV     A,R4
                CALL    XPAGE0
                MOV     A,R3
                CALL    ADDR0
	        MOV     DPTR,#M222
	        MOV     R7,#0
DISP2LEG:       MOV     A,R7
                MOVC    A,@A+DPTR
                CALL    FONT0
                INC     R7
                CJNE    R7,#16,DISP2LEG
                MOV     R4,B
                RET


MARIO11:        MOV     A,R4
                CALL    XPAGE1
                MOV     A,R3
                CALL    ADDR1
	        MOV     DPTR,#M1
	        MOV     R7,#0
DISP11:	        MOV     A,R7
                MOVC    A,@A+DPTR
                CALL    FONT1
                INC     R7
                CJNE    R7,#16,DISP11
                RET
                
MARIO11BODY:    MOV     B,R4
                INC     R4
                MOV     A,R4
                CALL    XPAGE1
                MOV     A,R3
                CALL    ADDR1
	        MOV     DPTR,#M11
	        MOV     R7,#0
DISP11BODY:     MOV     A,R7
                MOVC    A,@A+DPTR
                CALL    FONT1
                INC     R7
                CJNE    R7,#16,DISP11BODY
                MOV     R4,B
                RET
                
MARIO11LEG:     MOV     B,R4
                INC     R4
                INC     R4
                MOV     A,R4
                CALL    XPAGE1
                MOV     A,R3
                CALL    ADDR1
	        MOV     DPTR,#M111
	        MOV     R7,#0
DISP11LEG:      MOV     A,R7
                MOVC    A,@A+DPTR
                CALL    FONT1
                INC     R7
                CJNE    R7,#16,DISP11LEG
                MOV     R4, B
                RET

MARIO12:MOV     A,R4        
        CALL    XPAGE1
        MOV     A,R3        
        CALL    ADDR1
	MOV     DPTR,#M2
	MOV	R7,#0
DISP12: MOV     A,R7         
        MOVC    A,@A+DPTR    
        CALL    FONT1        
        INC     R7          
        CJNE    R7,#16,DISP12
        RET
        
MARIO12BODY:    MOV     B,R4
                INC     R4
                MOV     A,R4
                CALL    XPAGE1
                MOV     A,R3
                CALL    ADDR1
	        MOV     DPTR,#M22
	        MOV     R7,#0
DISP12BODY:     MOV     A,R7
                MOVC    A,@A+DPTR
                CALL    FONT1
                INC     R7
                CJNE    R7,#16,DISP12BODY
                MOV     R4,B
                RET

MARIO12LEG:     MOV     B,R4
                INC     R4
                INC     R4
                MOV     A,R4
                CALL    XPAGE1
                MOV     A,R3
                CALL    ADDR1
	        MOV     DPTR,#M222
	        MOV     R7,#0
DISP12LEG:      MOV     A,R7
                MOVC    A,@A+DPTR
                CALL    FONT1
                INC     R7
                CJNE    R7,#16,DISP12LEG
                MOV     R4, B
                RET

; COIN LCD0, LCD1
COIN1:  MOV     A,#1         
        CALL    XPAGE0
        MOV     A,#48
        CALL    ADDR0
	MOV     DPTR,#C1
	MOV     R7,#0
CDISP1:	MOV     A,R7        
        MOVC    A,@A+DPTR    
        CALL    FONT0       
        INC     R7           
        CJNE    R7,#16,CDISP1
        RET

COIN2:  MOV     A,#2
        CALL    XPAGE0
        MOV     A,#48
        CALL    ADDR0
	MOV     DPTR,#C11
	MOV     R7,#0
CDISP2:	MOV     A,R7        
        MOVC    A,@A+DPTR    
        CALL    FONT0
        INC     R7           
        CJNE    R7,#16,CDISP2
        RET


; SCORE LCD0, LCD1
SCORE:  MOV     A,#1         
        CALL    XPAGE1
        MOV     A,#48
        CALL    ADDR1
	MOV     DPTR,#S1
	MOV     R7,#0
SDISP:	MOV     A,R7        
        MOVC    A,@A+DPTR    
        CALL    FONT1       
        INC     R7           
        CJNE    R7,#16,SDISP
        RET

SCORE1: MOV     A,#1         
        CALL    XPAGE1
        MOV     A,#48
        CALL    ADDR1
	MOV     DPTR,#S2
	MOV     R7,#0
SDISP1:	MOV     A,R7        
        MOVC    A,@A+DPTR    
        CALL    FONT1       
        INC     R7           
        CJNE    R7,#16,SDISP1
        RET

M1:	DB 00000000B, 11000000B, 00110000B, 00001000B
	DB 11000100B, 11100010B, 00110001B, 00010001B
	DB 00011001B, 11011001B, 00011001B, 11011110B
	DB 10111000B, 10111000B, 00010000B, 00000000B

M11:	DB 10000000B, 01000111B, 00100100B, 00011000B	
	DB 10010001B, 10010011B, 10100001B, 01100100B
	DB 11100110B, 00101100B, 00101100B, 01111000B
	DB 11001000B, 10101100B, 00100111B, 11000100B

M111:	DB 01100011B, 10010100B, 10001110B, 01001001B
	DB 01110000B, 01110000B, 01110000B, 01111001B
	DB 00111111B, 00110011B, 00110010B, 00111100B
	DB 01001100B, 10000011B, 10000110B, 01111001B


M2:	DB 00000000B, 11000000B, 00110000B, 00001000B
	DB 11000100B, 11100010B, 00110001B, 00010001B
	DB 00011001B, 11011001B, 00011001B, 11011110B
	DB 10111000B, 10111000B, 00010000B, 00000000B	

M22:	DB 10000000B, 01000111B, 01000100B, 10011000B
	DB 11010001B, 01010011B, 01100001B, 00100100B
	DB 00100110B, 00101100B, 11101100B, 00101000B
	DB 00011000B, 00011100B, 00100111B, 11000100B

M222:	DB 01111011B, 10000100B, 10000010B, 01001111B
	DB 00110000B, 00110011B, 00110010B, 00111100B
	DB 00111100B, 00111100B, 00111100B, 01111101B
	DB 01001110B, 10001010B, 10010001B, 01100000B


C1:	DB 11100000B, 00110000B, 00011000B, 00001100B
	DB 00000110B, 01110011B, 10001001B, 11111111B
	DB 00000101B, 00001001B, 00000011B, 00000110B
	DB 00001100B, 00011000B, 00110000B, 11100000B

C11:	DB 00000111B, 00001100B, 00011000B, 00110000B
	DB 01100000B, 11010000B, 10100000B, 11111111B
	DB 10010001B, 10010001B, 11001110B, 01100000B
	DB 00110000B, 00011000B, 00001100B, 00000111B



S1:	DB 00011000B, 00100100B, 01000010B, 10000001B
	DB 10000001B, 01000010B, 00100100B, 00011000B
	DB 00011000B, 00100100B, 01000010B, 10000001B
	DB 10000001B, 01000010B, 00100100B, 00011000B

S2:	DB 10001000B, 10000100B, 10000010B, 11111111B
	DB 10000000B, 10000000B, 10000000B, 00000000B
	DB 00011000B, 00100100B, 01000010B, 10000001B
	DB 10000001B, 01000010B, 00100100B, 00011000B


$INCLUDE (LCD_IW.INC)
    
        END
