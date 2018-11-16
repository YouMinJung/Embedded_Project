SELECT  EQU     0FC48H       
      
        ORG     0000H
        JMP     START        
       
        ORG     000BH
        JMP     TIMER0       
      
        ORG     001BH
        JMP     TIMER1      
     
        ORG     0030H
START:  MOV     SP,#60H    
        MOV     PSW,#00H     
        MOV     TMOD,#0A1H
        
        MOV     TH1,#0
        MOV     TL1,#0
        MOV     TH0,#0
        MOV     TL0,#0
      
        MOV     A,#10001111B
        MOV     DPTR,#SELECT
        MOVX    @DPTR,A

LOOP:	CALL	F1
	CALL	F2
	CALL	F1
	CALL    F3
	JMP     LOOP
	

F1:	CALL	RA
	CALL	SEC2
	CALL	SOL
	CALL	SEC2
	CALL    PA
	CALL	SEC2
	CALL    SOL
	CALL	SEC2
	CALL	RA
	CALL	SEC2
	CALL    SEC2
	CALL	RA
	CALL	SEC2
	CALL	SEC2
	CALL	RA
	CALL	SEC2
	CALL	SEC2
	RET
	

F2:	CALL    SOL
        CALL	SEC2
        CALL	SEC2
        CALL    SOL
        CALL	SEC2
        CALL	SEC2
        CALL    SOL
        CALL	SEC2
        CALL	SEC2
        CALL    RA
        CALL	SEC2
        CALL	SEC2
        CALL    RA
        CALL	SEC2
        CALL	SEC2
        CALL    RA
        CALL	SEC2
        CALL	SEC2
        CALL	SEC2
        CALL    SEC2
        RET


F3:	CALL	SOL
        CALL	SEC2
        CALL    SOL
        CALL	SEC2
        CALL    RA
        CALL	SEC2
        CALL    SOL
        CALL	SEC2
        CALL    PA
        CALL	SEC2
        CALL	SEC2
        CALL	SEC2
        CALL	SEC2
        CALL	SEC2
        CALL	SEC2
        RET
	
       
TIMER0: INC     R4          
        RETI                
       
TIMER1: INC     R5        
        RETI
       

SOL:   MOV     R6,#180
        MOV     TH1,#0     
        MOV     TL1,#0
        SETB    ET1           
        SETB    TR1         
        SETB    EA
       
LOOP1:  MOV     R5,#0
        CLR     T0
                   
LP1:    CJNE    R5,#5,LP1
        MOV     R5,#0        
        SETB    T0     
      
LP2:    CJNE    R5,#4,LP2
        DJNZ    R6,LOOP1
        SETB    T0          
        CLR     TR1         
        CLR     ET1          
        CLR     EA
        RET

RA:   	MOV     R6,#200
        MOV     TH1,#0     
        MOV     TL1,#0
        SETB    ET1           
        SETB    TR1         
        SETB    EA
       
LOOP2:  MOV     R5,#0
        
        CLR     T0           
LP3:   CJNE    R5,#4,LP3
        MOV     R5,#0        
        SETB    T0     
      
LP4:   CJNE    R5,#4,LP4
        DJNZ    R6,LOOP2
        SETB    T0          
        CLR     TR1         
        CLR     ET1          
        CLR     EA
        RET

PA:   	MOV     R6,#125

        MOV     TH1,#0     
        MOV     TL1,#0
        SETB    ET1           
        SETB    TR1         
        SETB    EA
       
LOOP3:  MOV     R5,#0
        
        CLR     T0           
LP5:   CJNE    R5,#5,LP5
        MOV     R5,#0        
        SETB    T0     
      
LP6:   CJNE    R5,#5,LP6
        DJNZ    R6,LOOP3
        SETB    T0          
        CLR     TR1         
        CLR     ET1          
        CLR     EA
        RET

        
SEC2:   MOV     R4,#0
        SETB    ET0
        SETB    TR0
        SETB    EA
        SETB    T0
LP21:   CJNE    R4,#1,LP21
        CLR     TR0
        CLR     ET0
        CLR     EA
        RET

        END
