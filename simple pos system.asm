.MODEL LARGE  ;.MODEL MEDIUM CHANGED
.STACK 2000H
.DATA
    M1 DB '    Fruit Store Product Menu    ', 0DH, 0AH, '+===+===========================+', 10,'$'
    M2 DB 'Enter your Choise: $ '

    M3 DB '| 1 | - Apple          RM  3.00 |',10,'$'
    M4 DB '| 2 | - Orange         RM  2.00 |',10,'$'
    M5 DB '| 3 | - Pineapple      RM  6.00 |',10,'$'
    M6 DB '| 4 | - Watermelon     RM 24.00 |',10,'$'
    M7 DB '| 5 | - Guava          RM  5.00 |',10,'$'
    M8 DB '+===+---------------------------+', 0DH, 0AH, '| 6 | Exit |', 0DH, 0AH, '+---+------+', 0DH, 0AH, 10,'$'

    ;INVALID
	M9 DB '	 INVALID ENTRY	&&***',10,'$'
	M10 DB '***&&	Please try again	   &&***',10,'$'
    M11 DB '***&&     Thank for your shopping    &&***',10,'$'
    M12 DB ' ***&&         Have a nice day!    &&***',10,'$'

    ;COMMAND
    M13 DB 'Total Quantity             : $'
    M14 DB 'Final Prices(5%)           : $'
	M15 DB 'Enter your order           : $'
	M16 DB 'Quantity [Under 999]       : $'
	M17 DB 'Total Price(INCLUDE SST)   : $'      
	M18 DB '1.Go Back to Main Menu',10,'$'
	M19 DB '2.EXIT',10,'$'
    M20 DB 'Next Customer?(Y/N)        :$'

    ;RECIPT
    M21 DB 'APPLE(Total Price)     : $'
    M22 DB 'ORANGE(Total Price)    : $'
    M23 DB 'PINEAPPLE(Total Price) : $'
    M24 DB 'WATERMELON(Total Price): $'
    M25 DB 'GUAVA(Total Price)     : $'
    M26 DB 'DAILY EARN             : $'
    M27 DB 'CUSTOMER NO            : $'

    ;PASSWORD
    LG1 DB "Enter Password(8989): $"
    PASSWORD1 DB ?
    PASSWORD2 DB ?
    PASSWORD3 DB ?
    PASSWORD4 DB ?
    R1 DB "Login Successfuly$"
    R2 DB "Incorrect Password$"
    NL DB 0DH,0AH,"$"   
    ;DATA STORE
    QUANTITY DW 0,0,0,0,0
    DAILYEARN DW 0
    DAILYEARN2 DW 0
    DAILYEARNDIGIT DW 0
	TOTAL DW 0
    SSTPRICE DW 0
    SSTPRICEDIGIT DW 0
    Price DW 3,2,6,24,5
    DOT DB '.$'
    CUSTOMERNO DW 1
    TOTAL1 DW 0
        
    ;NEXT LINE
    NEXTLINE DB 13, 10, "$"
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
TOTALDAILYEARN PROC
    MOV AX,TOTAL
    ADD DAILYEARN,AX

    XOR AX,AX
    XOR BX,BX
    XOR DX,DX

    MOV AX,SSTPRICEDIGIT
    ADD DAILYEARNDIGIT,AX

    MOV AX,DAILYEARNDIGIT
    MOV BX,100
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
    LEA DX,M2 ;SHOW 'Enter your Choise ',10,'$'
    MOV AH,9
    INT 21H

    CALL NEWLINE

    LEA DX,M18 ;'1.Go Back to Main Menu',10,'$'
    MOV AH,9
    INT 21H

    LEA DX,M19 ;SHOW '2.EXIT',10,'$'
    MOV AH,9
    INT 21H

    MOV AH,1 ;INPUT VALUE
    INT 21H
    MOV BH,AL
    SUB BH,48

    CALL NEWLINE

    RET
CHOICE ENDP
MENU PROC
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
INVALID PROC
    CALL NEWLINE

    CALL NEWLINE

    LEA DX,M9 ;'***&&	INVALID ENTRY	&&***',10,'$'
    MOV AH,9
    INT 21H

    LEA DX,M10 ;'***&&	  Try Again	&&***',10,'$'
    MOV AH,9
    INT 21H

    CALL NEWLINE

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
SCANTWODIGITNUMBER ENDP
EXIT PROC
    LEA DX,M11 ;'***&&     Thank for your shopping    &&***',10,'$'
    MOV AH,9
    INT 21H

    LEA DX,M12 ;'***&&     Have a nice day!    &&***',10,'$'
    MOV AH,9
    INT 21H

    MOV AH,4CH
    INT 21H
EXIT ENDP
RECIPT PROC
    CALL NEWLINE

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

    LEA SI,QUANTITY

    MOV AX,[SI+8]
    CALL PRINT

    CALL NEWLINE

    JMP RECIPT5

RECIPT5:
;COMPLETE GENERATE 
    LEA DX,M14 ;'FINAL PRICES'
    MOV AH,9
    INT 21H

    MOV AX,SSTPRICE
    CALL PRINT
    
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

    RET
RECIPT ENDP
SST PROC
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

    LEA SI,QUANTITY
    MOV AX,[SI+0]
    CMP AX,0000H
    RET
SST ENDP
PASSWORDS PROC
    MOV CH,30H

    MOV AH,09H
    LEA DX,LG1
    INT 21H

    MOV AH,01H
    INT 21H
    SUB AL,30H

    MOV PASSWORD1,AL
    MOV CH,PASSWORD1
    ; first digit

    MOV AH,01H
    INT 21H
    SUB AL,30H

    MOV PASSWORD2,AL
    MOV CL,PASSWORD2
    ;second digit

    MOV AH,01H
    INT 21H
    SUB AL,30H

    MOV PASSWORD3,AL
    MOV BH,PASSWORD3
    ;third digit

    MOV AH,01H
    INT 21H
    SUB AL,30H

    MOV PASSWORD4,AL
    MOV DH,PASSWORD4
    ;fourth digit

    CMP CH, 8 
    JNE INVALIDPASSWORD

    CMP CL, 9 
    JNE INVALIDPASSWORD

    CMP BH, 8 
    JNE INVALIDPASSWORD

    CMP DH, 9 
    JNE INVALIDPASSWORD
    JMP SUCCESS

INVALIDPASSWORD:
    CALL NEWLINE

    MOV AH,09H
    LEA DX,NL
    INT 21H

    CALL NEWLINE

    MOV AH,09H
    LEA DX,R2
    INT 21H

    CALL NEWLINE
    CALL EXIT

SUCCESS:
    CALL NEWLINE

    MOV AH,09H
    LEA DX,NL
    INT 21H

    CALL NEWLINE

    MOV AH,09H
    LEA DX,R1
    INT 21H

    CALL NEWLINE
    RET
PASSWORDS ENDP
;DX = NAME STROING PLACES
;CX = LOOPING PLACES
;BX = CALCULATING PLACE
MAIN PROC 
    MOV AX,@DATA
    MOV DS,AX
;LOGIN START
    CALL PASSWORDS
;MENU START
SHOWMENU:    
    CALL MENU

    LEA DX,M2 ;SHOW 'Enter your Choise ',10,'$'
    MOV AH,9
    INT 21H

    MOV AH,1 ;INPUT VALUE
    INT 21H
    MOV BH,AL
    SUB BH,48

    CALL NEWLINE

    CMP BH,1 ;JUMP APPLE
    JE APPLE

    JMP ORANGE1
APPLE:

    CALL OUTPRINTQUANTITY
    CALL SCANTWODIGITNUMBER
    MOV SI,OFFSET QUANTITY
    MOV [SI+0], AX    ; Store the final number in the variable "number"

    CALL NEWLINE

    CALL CHOICE
    CMP BH,1 ;
    JE SHOWMENU

    CMP BH,2
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
    MOV [SI+2], AX   ; Store the final number in the variable "number"

    CALL NEWLINE

    CALL CHOICE
    CMP BH,1 ;
    JE SHOWMENU

    CMP BH,2
    JE COUNTSST1

    CALL INVALID
    JMP ORANGE

PINEAPPLE1:
    CMP BH,3 ;JUMP PINEAPPLE
    JE PINEAPPLE

    JMP WATERMELON1
SHOWMENU1:
    JMP SHOWMENU
PINEAPPLE:
    CALL OUTPRINTQUANTITY

    CALL SCANTWODIGITNUMBER
    MOV SI,OFFSET QUANTITY
    MOV [SI+4], AX    ; Store the final number in the variable "number"

    CALL NEWLINE

    CALL CHOICE
    CMP BH,1 ;
    JE SHOWMENU1

    CMP BH,2
    JE COUNTSST1

    CALL INVALID
    JMP PINEAPPLE

WATERMELON1:
    CMP BH,4 ;JUMP WATERMELON
    JE WATERMELON

    JMP GUAVA1
COUNTSST1:
    JMP COUNTSST
WATERMELON:
    CALL OUTPRINTQUANTITY

    CALL SCANTWODIGITNUMBER
    MOV SI,OFFSET QUANTITY
    MOV [SI+6], AX   ; Store the final number in the variable "number"

    CALL NEWLINE

    CALL CHOICE
    CMP BH,1 ;
    JE SHOWMENU1

    CMP BH,2
    JE COUNTSST

    CALL INVALID
    JMP WATERMELON

GUAVA1:
    CMP BH,5 ;JUMP GUAVA
    JE GUAVA

    JMP DEFINEEXIT1
SHOWMENU2:
    JMP SHOWMENU1
GUAVA:
    CALL OUTPRINTQUANTITY

    CALL SCANTWODIGITNUMBER
    MOV SI,OFFSET QUANTITY
    MOV [SI+8], AX    ; Store the final number in the variable "number"

    CALL NEWLINE

    CALL CHOICE
    CMP BH,1 ;
    JE SHOWMENU2

    CMP BH,2
    JE COUNTSST

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

NEXTCUSTOMER:
    CALL TOTALDAILYEARN

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
    MOV AX,CUSTOMERNO
    INC AX
    MOV CUSTOMERNO,AX

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