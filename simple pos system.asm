.MODEL LARGE  ;.MODEL MEDIUM CHANGED
.STACK 2000H
.DATA
    M1 DB '	|    Fruit Store Product Menu    ', 0DH, 0AH, '	+===+===========================+', 10,'$'
    M2 DB 'Enter your choice > $ '

    M3 DB '	| 1 | - Apple          RM  3.00 |',10,'$'
    M4 DB '	| 2 | - Orange         RM  2.00 |',10,'$'
    M5 DB '	| 3 | - Pineapple      RM  6.00 |',10,'$'
    M6 DB '	| 4 | - Watermelon     RM 24.00 |',10,'$'
    M7 DB '	| 5 | - Guava          RM  5.00 |',10,'$'
    M8 DB '	+===+---------------------------+', 0DH, 0AH, '	| 6 | Exit |', 0DH, 0AH, '	+---+------+', 0DH, 0AH, 10,'$'

    ;INVALID
	M9 DB  '	     INVALID ENTRY    ', 0DH, 0AH, '	    Please try again    ', 10, '$'
    M11 DB '	Here is your receipt. Have a nice day!',10,'$'

    ;COMMAND
    ;M13 DB 'Total Quantity             : $'
	M16 DB 'Quantity [Under 99]       : $'
	M18 DB 'Continue order item?(Y/N) > $'
    M20 DB 'Go to next order?(Y/N) > $'
	
	M26 DB '	Total sales earn         : RM $'
	M29 DB '	Total number of Customer : $'
	M28 DB '               QUANTITY SET $'
	
    ;RECIPT
    M27 DB '	| @ CUSTOMER Order NO: $'
    M21 DB '	| - APPLE        RM  3.00   | $'
    M22 DB '	| - ORANGE       RM  2.00   | $'
    M23 DB '	| - PINEAPPLE    RM  6.00   | $'
    M24 DB '	| - WATERMELON   RM 24.00   | $'
    M25 DB '	| - GUAVA        RM  5.00   | $'
	M14 DB '	| SST Tax (5%)              : RM $'
	M17 DB '	| Total Price               : RM $'
	M30 DB '	+===========================+====+-----------', 0DH, 0AH, '$'
	M31 DB '	|  Product        Price    Quantity Subtotal', 0DH, 0AH, '$'

    M32 DB '       ,--./,-.     ', 0DH, 0AH, '$'
    M33 DB '      / #      \    ', 0DH, 0AH, '$'
	M34 DB '     |          |   ', 0DH, 0AH, '$'
    M35 DB '      \        /    ', 0DH, 0AH, '$'
    M36 DB '       \._,._,;     ', 0DH, 0AH, '$'   
    M37 DB 'WELLCOME TO FRUIT HAVEN', 0DH, 0AH, '$'
    M38 DB '(A Paradise of Freshness)', 0DH, 0AH, '$'

    ;PASSWORD
    LG1 DB "Enter 4-digit password: $"
    STRPASSWORD LABEL BYTE
    MAXIN DB 5
    ACTN DB ?
    INPUTSTR DB 5 DUP("$")
    ADMINPASSWORD DB "8989$"

    R1 DB "	 -- Login Succeeded. --$"
    R2 DB "	  -- Incorrect Password. --$"
	R3 DB "	 -- The system is closed... --", 10, '$'
    NL DB 0DH,0AH,"$"   
    ;DATA STORE
    QUANTITY DW 0,0,0,0,0
	QUANTITY2 DW 0,0,0,0,0
    BOOLEAN DW ?
    DAILYEARN DW 0
    DAILYEARN2 DW 0
    DAILYEARNDIGIT DW 0
	TOTAL DW 0
    SSTPRICE DW 0
    SSTPRICEDIGIT DW 0
    Price DW 3,2,6,24,5
    DOT DB '.$'
	RECIPTMIDDLE DB ' | RM $'
    CUSTOMERNO DW 1
    TOTAL1 DW 0
	TEN DB 10
     
    ;NEXT LINE
    NEXTLINE DB 13, 10, "$"
    EMPTYSPACES DB "      $"
.CODE
PRINT PROC
    MOV CX,0
    MOV DX,0
    LABELPRINT:
        CMP AX,0
        JE PRINTAX

        MOV BX,10
        DIV BX
        PUSH DX
        INC CX
        XOR DX,DX
        JMP LABELPRINT
    PRINTAX:
        CMP CX,0
        JE EXITPRINT

        POP DX
        ADD DX,48
        MOV AH,02h
        INT 21H

        LOOP PRINTAX
	EXITPRINT:
	RET
PRINT ENDP
QUANTITYPRINT PROC
	MOV AH, 0
	DIV TEN
	MOV BX, AX
	
	CMP BL, 0
	
	MOV AH, 02H
	MOV DL, BL
	
	CMP DL, 0
	JE IS0
		ADD DL, 30H
		JMP QNUM1
	IS0:
		MOV DL, ' '
		
	QNUM1:
		INT 21H
	MOV AH, 02H
	MOV DL, BH
	ADD DL, 30H
	INT 21H
	
	MOV AH, 09H
	LEA DX, RECIPTMIDDLE
	INT 21H
	RET
QUANTITYPRINT ENDP
;description
QUANTITYOUTPUT PROC
    LEA DX,M28
    MOV AH,09H
    INT 21H
QUANTITYOUTPUT ENDP
TOTALDAILYEARN PROC
    MOV AX,TOTAL
    ADD DAILYEARN,AX

    XOR AX,AX
    XOR BX,BX
    XOR DX,DX

    MOV AX,SSTPRICEDIGIT
    ADD DAILYEARNDIGIT,AX

    MOV AX,DAILYEARNDIGIT
    MOV BX,1000
    DIV BX

    ADD DAILYEARN,AX
    MOV DAILYEARNDIGIT,DX
    RET
TOTALDAILYEARN ENDP
NEWLINE PROC
    LEA DX,NEXTLINE ;NEWLINE
    MOV AH,09H
    INT 21H
    RET
NEWLINE ENDP
OUTPRINTQUANTITY PROC
    LEA DX,M16 ;'Quantity: $'
    MOV AH,09H
    INT 21H
    RET
OUTPRINTQUANTITY ENDP
CHOICE PROC
    LEA DX,M18
    MOV AH,9
    INT 21H

    MOV AH,1 ;INPUT VALUE
    INT 21H
    MOV BH,AL

    CALL NEWLINE

    RET
CHOICE ENDP
MENU PROC
    MOV AX,3
    INT 10H
    CALL NEWLINE
	CALL NEWLINE
    LEA DX,M27
    MOV AH,9
    INT 21H

    MOV AX,CUSTOMERNO
    CALL PRINT

    CALL NEWLINE

    LEA DX,M1 ;SHOW '****Welcome to Fruit Haven****',10,'$'
    MOV AH,9
    INT 21H

    LEA DX,M3 ;SHOW '**   1.Apple              **' ,10,'$'
    MOV AH,9
    INT 21H

    LEA DX,M4 ;SHOW '**   2.Orange             **',10,'$'
    MOV AH,9
    INT 21H

    LEA DX,M5 ;SHOW '**   3.Pineapple          **',10,'$'
    MOV AH,9
    INT 21H

    LEA DX,M6 ;SHOW '**   4.Watermelon         **',10,'$'
    MOV AH,9
    INT 21H

    LEA DX,M7 ;SHOW '**   5.Guava              **',10,'$'
    MOV AH,9
    INT 21H

    LEA DX,M8 ;SHOW '**   6.Exit               **',10,'$'
    MOV AH,9
    INT 21H

    RET
MENU ENDP
;description

INVALID PROC
    CALL NEWLINE
    CALL NEWLINE

    mov ah, 9
    mov al, ''     ; Character to print (space to set the background color)
    mov bh, 0       ; Page number (usually 0)
    mov bl, 00CH       ; Attribute byte (background color is 0 (black), foreground color is 4 (red))
    MOV CX,0050H
    MOV DX,0C4FH
    int 10h

    LEA DX,M9 ;'***&&	INVALID ENTRY	&&***',10,'$'
    MOV AH,9
    INT 21H

    CALL NEWLINE
    XOR AX,AX
    XOR CX,CX
    XOR BX,BX
    XOR DX,DX
    MOV AH,08H
    INT 21H
    RET
INVALID ENDP
SCANTWODIGITNUMBER PROC
    XOR AX,AX
    XOR BX,BX
    XOR CX,CX
    XOR DX,DX

JUDGESIGN:
    MOV AH,1
    INT 21H
    CMP AL,'-'
    JNE NEXT
    MOV DX,0FFFFH
    JMP DIGITIN

NEXT:
    CMP AL,30H
    JB UNEXPECTED
    CMP AL,39H
    JA UNEXPECTED
    SUB AL,30H
    SHL BX,1
    MOV CX,BX
    SHL BX,1
    SHL BX,1
    ADD BX,CX
    ADD BL,AL
    ADC BH,0

DIGITIN:
    MOV AH,1
    INT 21H
    JMP NEXT

SAVE:
    CMP DX,0FFFFH
    JNE RESULTSAVE
    NEG BX

RESULTSAVE:
    MOV AX,BX
    RET

UNEXPECTED:
    CMP AL,0DH
    JE SAVE
    CALL INVALID
    JMP MENU
SCANTWODIGITNUMBER ENDP
DISPLAYDATE PROC
    MOV DL,BH
    ADD DL,30H
    MOV AH,02H
    INT 21H
    MOV DL,BL
    ADD DL,30H
    MOV AH,02H
    INT 21H
    RET
DISPLAYDATE ENDP
;description
SHOWDATE PROC
    ;description
    MOV AH,2AH
    INT 21H
    MOV AL,DL
    AAM
    MOV BX,AX
    CALL DISPLAYDATE

    MOV DL,'/'
    MOV AH,02H
    INT 21H

    MOV AH,2AH
    INT 21H
    MOV AL,DH
    AAM
    MOV BX,AX
    CALL DISPLAYDATE

    MOV DL,'/'
    MOV AH,02H
    INT 21H

    MOV AH,2AH
    INT 21H
    ADD CX,0F830H
    MOV AX,CX
    AAM
    MOV BX,AX
    CALL DISPLAYDATE

    RET
SHOWDATE ENDP
EXIT PROC
	MOV AX, CUSTOMERNO
	DEC AX
	CMP AX, 0
	
	JE SYSEND
		LEA DX, M29 ;"The total number of customer: "
		MOV AH, 9
		INT 21H
		
		MOV AX, CUSTOMERNO
		DEC AX
		CALL PRINT
		CALL NEWLINE
	SYSEND:
    LEA DX,R3 ;' -- The system is closed. --'
    MOV AH,9
    INT 21H

    MOV AH,4CH
    INT 21H
EXIT ENDP
RECIPT PROC
    MOV AX,3
    INT 10H
    CALL NEWLINE
	CALL NEWLINE
	CALL NEWLINE
	
	; PRINT CUSTOMER ORDER NUMBER
	MOV AH, 9
	LEA DX, M27
	INT 21H

	MOV AX, CUSTOMERNO
	CALL PRINT

    LEA DX,EMPTYSPACES
    MOV AH,9
    INT 21H
    CALL SHOWDATE

	CALL NEWLINE
	INC CUSTOMERNO
	
	; ORDER LINE BREAK
	MOV AH, 09H
	LEA DX, M30
	INT 21H
	
	MOV AH, 09H
	LEA DX, M31
	INT 21H
	
	MOV AH, 09H
	LEA DX, M30
	INT 21H
	
;GENEARATE NAME AND QUANTITY
    LEA SI,QUANTITY
    MOV AX,[SI+0]
    CMP AX,0000H
    JG RECIPTAPPLE

    JMP RECIPT1
RECIPTAPPLE:
    LEA DX,M21 ; M21 DB 'APPLE:  $'
    MOV AH,9
    INT 21H

    LEA SI,QUANTITY2
    MOV AX,[SI]
    CALL QUANTITYPRINT
	
	LEA SI,QUANTITY
    MOV AX,[SI]
    CALL PRINT

    CALL NEWLINE

    JMP RECIPT1

RECIPT1:
    LEA SI,QUANTITY
    MOV AX,[SI+2]
    CMP AX,0000H
    JG RECIPTORANGE

    JMP RECIPT2
RECIPTORANGE:
    LEA DX,M22 ; 'ORANGE: $'
    MOV AH,9
    INT 21H

	LEA SI,QUANTITY2
    MOV AX,[SI+2]
    CALL QUANTITYPRINT
	
    LEA SI,QUANTITY
    MOV AX,[SI+2]
    CALL PRINT

    CALL NEWLINE

    JMP RECIPT2

RECIPT2:
    LEA SI,QUANTITY
    MOV AX,[SI+4]
    CMP AX,0000H
    JG RECIPTPINEAPPLE

    JMP RECIPT3

RECIPTPINEAPPLE:
    LEA DX,M23 ; 'PINEAPPLE: $'
    MOV AH,9
    INT 21H

	LEA SI,QUANTITY2
    MOV AX,[SI+4]
    CALL QUANTITYPRINT
	
    LEA SI,QUANTITY
    MOV AX,[SI+4]
    CALL PRINT

    CALL NEWLINE

    JMP RECIPT3

RECIPT3:
    LEA SI,QUANTITY
    MOV AX,[SI+6]
    CMP AX,0000H
    JG RECIPTWATERMELON

    JMP RECIPT4

RECIPTWATERMELON:
    LEA DX,M24 ; 'WATERMELON: $'
    MOV AH,9
    INT 21H

	LEA SI,QUANTITY2
    MOV AX,[SI+6]
    CALL QUANTITYPRINT
	
    LEA SI,QUANTITY
    MOV AX,[SI+6]
    CALL PRINT

    CALL NEWLINE

    JMP RECIPT4
    
RECIPT4:
    LEA SI,QUANTITY
    MOV AX,[SI+8]
    CMP AX,0000H
    JG RECIPTGUAVA

    JMP RECIPT5

RECIPTGUAVA:
    LEA DX,M25 ; 'GUAVA: $'
    MOV AH,9
    INT 21H

	LEA SI,QUANTITY2
    MOV AX,[SI+8]
    CALL QUANTITYPRINT
	
    LEA SI,QUANTITY
    MOV AX,[SI+8]
    CALL PRINT

    CALL NEWLINE

    JMP RECIPT5

RECIPT5:
	;COMPLETE GENERATE 
	MOV AH, 09H
	LEA DX, M30 ;ORDER LINE BREAK
	INT 21H
	
    LEA DX,M14 ;'SST TAX PRICE'
    MOV AH,9
    INT 21H

    MOV AX,SSTPRICE
    CMP AX,0
    JNZ PRINTSSTPRICE
    MOV DX,48
    MOV AH,02H
    INT 21H

    JMP PRINTSSTPRICEDIGIT

PRINTSSTPRICE:
    CALL PRINT

PRINTSSTPRICEDIGIT:
    MOV AX,SSTPRICEDIGIT
    CMP AX,0
    JZ NODOT

    MOV DX,OFFSET DOT
    MOV AH,9
    INT 21H

    MOV AX,SSTPRICEDIGIT
    CALL PRINT

NODOT:
    CALL NEWLINE
    
    LEA DX,M17 ; PRINT 'Total Price: $' 
    MOV AH,9
    INT 21H

    MOV AX,TOTAL
    CALL PRINT
    
    MOV AX,SSTPRICEDIGIT
    CMP AX,0
    JZ NODOT2

    MOV DX,OFFSET DOT
    MOV AH,9
    INT 21H

    MOV AX,SSTPRICEDIGIT
    CALL PRINT

NODOT2:
    CALL NEWLINE

	MOV AH, 09H
	LEA DX, M30
	INT 21H
	
	CALL NEWLINE
	MOV AH, 09H
	LEA DX, M11
	INT 21H
	
	CALL NEWLINE
	
    RET
	
RECIPT ENDP
SST PROC
    MOV CX,5
    LEA SI,QUANTITY2
    LEA DI,QUANTITY
    XOR AX,AX

	LOOP0:
		MOV AX,[DI]
		MOV [SI],AX
		ADD SI,2
		ADD DI,2
	LOOP LOOP0
	

    MOV CX,5
    LEA SI,Price
    LEA DI,QUANTITY
    XOR AX,AX

LOOP1:
    MOV AX,[SI]
    MOV BX,[DI]
    MUL BX
    
    MOV [DI],AX
    ADD SI,2
    ADD DI,2
    LOOP LOOP1 

    LEA DI,QUANTITY
    MOV AX,0000H
    MOV CX,5

LOOPTOTAL:
    MOV AX,[DI]
    MOV BX,TOTAL
    ADD DX,AX

    ADD DI,2
    LOOP LOOPTOTAL

    MOV TOTAL1,DX
    MOV AX,DX
    MOV BX,5
    MUL BX

    MOV BX,100
    DIV BX
  
    MOV SSTPRICE,AX

    MOV AX,DX

    MOV SSTPRICEDIGIT,AX
    MOV AX,SSTPRICE
    MOV BX,TOTAL1
    ADD AX,BX
    MOV TOTAL,AX

    MOV AX,SSTPRICEDIGIT
    MOV BX,10
    MUL BX
    MOV SSTPRICEDIGIT,AX

    LEA SI,QUANTITY
    MOV AX,[SI+0]
    CMP AX,0000H
    RET
SST ENDP
PASSWORDS PROC
    LEA DX,LG1 ;"Enter 4-digit password: $"
    MOV AH,9
    INT 21H

    MOV AH,0AH
    LEA DX,STRPASSWORD
    INT 21H

    MOV AH, 09H
	LEA DX, NL
	INT 21H

    MOV AL,ADMINPASSWORD
    CMP INPUTSTR,AL
    JNE INVALIDPASSWORD

SUCCESS:
    CALL NEWLINE
	CALL NEWLINE

    MOV AH,09H
    LEA DX,R1
    INT 21H
	
	CALL NEWLINE
	CALL NEWLINE
    CALL NEWLINE
    RET

INVALIDPASSWORD:
    CALL NEWLINE
    CALL NEWLINE

    MOV AH,09H
    LEA DX,R2
    INT 21H

	CALL NEWLINE
	CALL NEWLINE
    CALL EXIT

PASSWORDS ENDP
;description
DEFINEERROR PROC
    CMP BOOLEAN,1
    JE ERROR
    RET
ERROR:
    CALL INVALID
    MOV BOOLEAN,0
    RET
DEFINEERROR ENDP
;DX = NAME STROING PLACES
;CX = LOOPING PLACES
;BX = CALCULATING PLACE
MAIN PROC 
    MOV AX,@DATA
    MOV DS,AX
;LOGIN START
    MOV AL,03H;SET VIDEO MODE
    MOV AH,0
    INT 10H

    mov ah, 9
    mov al, ''     ; Character to print (space to set the background color)
    mov bh, 0       ; Page number (usually 0)
    mov bl, 4       ; Attribute byte (background color is 0 (black), foreground color is 4 (red))
    MOV CX,01F0H
    MOV DX,0C4FH
    int 10h

    LEA DX,M32 
    MOV AH,9
    INT 21H

    LEA DX,M33
    MOV AH,9
    INT 21H

    LEA DX,M34 
    MOV AH,9
    INT 21H

    LEA DX,M35 
    MOV AH,9
    INT 21H

    LEA DX,M36 
    MOV AH,9
    INT 21H

    CALL NEWLINE
    CALL NEWLINE

    mov ah, 9
    mov al, ''     ; Character to print (space to set the background color)
    mov bh, 0       ; Page number (usually 0)
    mov bl, 9       ; Attribute byte (background color is 0 (black), foreground color is 4 (red))
    MOV CX,0050H
    MOV DX,0C4FH
    int 10h

    LEA DX,M37
    MOV AH,9
    INT 21H

    mov ah, 9
    mov al, ''     ; Character to print (space to set the background color)
    mov bh, 0       ; Page number (usually 0)
    mov bl, 00AH       ; Attribute byte (background color is 0 (black), foreground color is 4 (red))
    MOV CX,0050H
    MOV DX,0C4FH
    int 10h

    LEA DX,M38 
    MOV AH,9
    INT 21H

    CALL NEWLINE
    CALL NEWLINE
    CALL PASSWORDS
;MENU START
SHOWMENU:
    CALL DEFINEERROR
    CALL MENU
    LEA DX,M2 ;SHOW 'Enter your Choise ',10,'$'
    MOV AH,9
    INT 21H

    MOV AH,1 ;INPUT VALUE
    INT 21H
    MOV BH,AL
    SUB BH,48

    CALL NEWLINE
	
	;------------------- Selection Checking
    CMP BH,1 ;JUMP APPLE
    JE APPLE

    JMP ORANGE1
APPLE:
    CALL OUTPRINTQUANTITY
    CALL SCANTWODIGITNUMBER
    MOV SI,OFFSET QUANTITY
    
    CMP AX,99
    MOV BOOLEAN,1
    JA SHOWMENU
	MOV [SI+0], AX    ; Store the final number in the variable "number"
	MOV BOOLEAN,0
	CALL QUANTITYOUTPUT
	MOV AX,[SI]
    CALL PRINT
    CALL NEWLINE

    CALL CHOICE
    CMP BH, 'Y';
    JE SHOWMENU
	CMP BH, 'y';
    JE SHOWMENU

    CMP BH, 'N';
    JE COUNTSST1
	CMP BH, 'n';
    JE COUNTSST1

    CALL INVALID
    JMP APPLE

ORANGE1:
    CMP BH,2 ;JUMP ORANGE
    JE ORANGE

    JMP PINEAPPLE1
ORANGE:
    CALL OUTPRINTQUANTITY
    CALL SCANTWODIGITNUMBER
    MOV SI,OFFSET QUANTITY
    
    CMP AX,99
    MOV BOOLEAN,1
    JA SHOWMENU1
	MOV [SI+2], AX   ; Store the final number in the variable "number"
	MOV BOOLEAN,0
	CALL QUANTITYOUTPUT
	MOV AX,[SI+2]
    CALL PRINT
    CALL NEWLINE

    CALL CHOICE
    CMP BH, 'Y';
    JE SHOWMENU1
	CMP BH, 'y';
    JE SHOWMENU1

    CMP BH, 'N';
    JE COUNTSST1
	CMP BH, 'n';
    JE COUNTSST1

    CALL INVALID
    JMP ORANGE

PINEAPPLE1:
    CMP BH,3 ;JUMP PINEAPPLE
    JE PINEAPPLE
	
    JMP WATERMELON1
SHOWMENU1:
    JMP SHOWMENU
COUNTSST1:
    JMP DEFINEEXIT
PINEAPPLE:
    CALL OUTPRINTQUANTITY
    CALL SCANTWODIGITNUMBER
    MOV SI,OFFSET QUANTITY
    

    CMP AX,99
    MOV BOOLEAN,1
    JA SHOWMENU1
	MOV [SI+4], AX    ; Store the final number in the variable "number"
	MOV BOOLEAN,0
	CALL QUANTITYOUTPUT
	MOV AX,[SI+4]
    CALL PRINT
    CALL NEWLINE

    CALL CHOICE
    CMP BH, 'Y';
    JE SHOWMENU1
	CMP BH, 'y';
    JE SHOWMENU1

    CMP BH, 'N';
    JE COUNTSST1
	CMP BH, 'n';
    JE COUNTSST1

    CALL INVALID
    JMP PINEAPPLE

WATERMELON1:
    CMP BH,4 ;JUMP WATERMELON
    JE WATERMELON

    JMP GUAVA1
WATERMELON:
    CALL OUTPRINTQUANTITY
    CALL SCANTWODIGITNUMBER
    MOV SI,OFFSET QUANTITY

    CMP AX,99
    MOV BOOLEAN,1
    JA SHOWMENU2
    MOV [SI+6], AX   ; Store the final number in the variable "number"
	MOV BOOLEAN,0
	CALL QUANTITYOUTPUT
	MOV AX,[SI+6]
    CALL PRINT
    CALL NEWLINE

    CALL CHOICE
    CMP BH, 'Y';
    JE SHOWMENU2
	CMP BH, 'y';
    JE SHOWMENU2

    CMP BH, 'N';
    JE COUNTSST2
	CMP BH, 'n';
    JE COUNTSST2

    CALL INVALID
    JMP WATERMELON

GUAVA1:
    CMP BH,5 ;JUMP GUAVA
    JE GUAVA

    JMP DEFINEEXIT1
SHOWMENU2:
    JMP SHOWMENU1
COUNTSST2:
	JMP DEFINEEXIT
GUAVA:
    CALL OUTPRINTQUANTITY
    CALL SCANTWODIGITNUMBER
    MOV SI,OFFSET QUANTITY
    
    CMP AX,99
    MOV BOOLEAN,1
    JA SHOWMENU2
    MOV [SI+8], AX    ; Store the final number in the variable "number"
	MOV BOOLEAN,0
	CALL QUANTITYOUTPUT
	MOV AX,[SI+8]
    CALL PRINT
    CALL NEWLINE

    CALL CHOICE
    CMP BH, 'Y';
    JE SHOWMENU2
	CMP BH, 'y';
    JE SHOWMENU2

    CMP BH, 'N';
    JE DEFINEEXIT
	CMP BH, 'n';
    JE DEFINEEXIT

    CALL INVALID
    JMP GUAVA

DEFINEEXIT1:
    CMP BH,6 ;JUMP EXIT
    JE DEFINEEXIT

    CALL INVALID
    JMP SHOWMENU

DEFINEEXIT:
    MOV CX,5
    LEA SI,QUANTITY
	
    LOOPEXIT:
        MOV AX,[SI]
        CMP AX,0
        JNE COUNTSST
		
        ADD SI,2
        LOOP LOOPEXIT

    JMP NEXTCUSTOMER

COUNTSST:
    CALL SST

SHOWRECIPT:
    CALL RECIPT
	CALL TOTALDAILYEARN

NEXTCUSTOMER:
    LEA DX,M20 ;'NEXT CUSTOMER'
    MOV AH,9
    INT 21H

    MOV AH,1 ;INPUT VALUE
    INT 21H
    MOV BH,AL

    CALL NEWLINE

    CMP BH,'y'
    JE SHOWMENU3

    CMP BH,'Y'
    JE SHOWMENU3

    CMP BH,'n'
    JE EXITSYSTEM

    CMP BH,'N'
    JE EXITSYSTEM

    JMP NEXTCUSTOMER

SHOWMENU3:
    LEA SI,QUANTITY
    MOV CX,5
    MOV AX,0000H
    LOOPCLEANQUANTITY:
        MOV [SI],AX
        ADD SI,2
        LOOP LOOPCLEANQUANTITY
    MOV AX,@DATA
    MOV DS,AX

    XOR AX,AX
    MOV TOTAL,AX
    MOV SSTPRICE,AX
    MOV SSTPRICEDIGIT,AX

    JMP SHOWMENU2

EXITSYSTEM:
	CALL NEWLINE
	CALL NEWLINE
    MOV AX,DAILYEARN
    CMP AX,0
    JE DOT1

    LEA DX,M26;'DAILY EARN'
    MOV AH,9
    INT 21H

    MOV AX,DAILYEARN
    CALL PRINT

DOT1:
    MOV AX,DAILYEARNDIGIT
    CMP AX,0
    JE NEWLINEEXIT

    MOV DX,OFFSET DOT
    MOV AH,9
    INT 21H
    
    MOV AX,DAILYEARNDIGIT
    CALL PRINT

NEWLINEEXIT:
    CALL NEWLINE

    CALL EXIT

MAIN ENDP
END MAIN