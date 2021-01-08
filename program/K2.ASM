
; CC5X Version 3.0G, Copyright (c) B. Knudsen Data
; C compiler for the PICmicro family
; ************   8. Feb 2001   1:53  *************

	processor  16C73A
	radix  DEC

PCL         EQU   0x02
STATUS      EQU   0x03
TRISB       EQU   0x86
PCLATH      EQU   0x0A
Zero_       EQU   2
RP0         EQU   5
GIE         EQU   7
PORTC       EQU   0x07
T2CON       EQU   0x12
CCPR1L      EQU   0x15
CCP1CON     EQU   0x17
CCPR2L      EQU   0x1B
CCP2CON     EQU   0x1D
TRISC       EQU   0x87
PR2         EQU   0x92
PEIE        EQU   6
TMR2IF      EQU   1
TMR2IE      EQU   1
intflag     EQU   0
neg         EQU   1
front       EQU   2
change      EQU   3
index       EQU   0x25
PWMHR       EQU   0
PWMLL       EQU   1
PWMLR       EQU   2
PWMHL       EQU   3
s1_save     EQU   0x20
s2          EQU   0x21
s3          EQU   0x22
tabindex    EQU   0x23

	GOTO main

  ; FILE D:\PRODUCT\1KW\PROGRAM\K2.C
			;/**********************************************
			;*	Filename:	main.c
			;*	Project:	2k1.pjt
			;*	Product name:	1kW sin waveform inverter
			;***********************************************
			;*
			;*	Author:		Feng Jiantao
			;*	Date:		2001.01.22
			;*	Compiled Using CC5Xfree package
			;*
			;**********************************************/
			;
			;#define OPEN_LOOP
			;//#define	FEEDBACK
			;
			;#define	F50Hz
			;//#define F60Hz
			;
			;#include <16C73A.H>
			;#include <int16cxx.H>
			;//#include "spwmtab.C"
			;
			;#define SPWMCOUNT 150
			;
			;bit intflag,neg,front,change;
			;unsigned char index;
			;
			;#pragma bit PWMHR @ 7.0
			;#pragma bit PWMLL @ 7.1		//CCP2
			;#pragma bit PWMLR @ 7.2		//CCP1
			;#pragma bit PWMHL @ 7.3
			;
			;#pragma bit LED_POWER	@  6.4
			;#pragma bit LED_LVD	@ 6.5
			;#pragma bit LED_PROTECT	@ 6.6
			;#pragma bit LED_WORK	@ 6.7
			;
			;unsigned char SPWMTAB(unsigned char tabindex);
			;
			;#pragma origin = 4
	ORG 0x0004
			;
			;interrupt int_server( void)
			;{
int_server
			;    	int_save_registers    // W, STATUS (and PCLATH)
	MOVWF s1_save
	SWAPF STATUS,W
	BCF   0x03,RP0
	MOVWF s2
	MOVF  PCLATH,W
	MOVWF s3
	CLRF  PCLATH
			;	intflag=1;
	BSF   0x24,intflag
			;	if(TMR2IF){
	BTFSS 0x0C,TMR2IF
	GOTO  m005
			;		if(neg){
	BTFSS 0x24,neg
	GOTO  m002
			;			CCPR1L=SPWMTAB(index);
	MOVF  index,W
	CALL  SPWMTAB
	BCF   0x03,RP0
	MOVWF CCPR1L
			;			if(change){
	BTFSS 0x24,change
	GOTO  m001
			;//				while(PWMLL);
			;				PWMHR=0;
	BCF   0x07,PWMHR
			;				PWMLL=0;
	BCF   0x07,PWMLL
			;				CCP2CON=0;
	CLRF  CCP2CON
			;				CCP1CON=0xc;
	MOVLW .12
	MOVWF CCP1CON
			;				PWMHL=1;
	BSF   0x07,PWMHL
			;				change=0;
	BCF   0x24,change
			;			}
			;			index++;
m001	BCF   0x03,RP0
	INCF  index,1
			;			if(index==SPWMCOUNT){
	MOVF  index,W
	XORLW .150
	BTFSS 0x03,Zero_
	GOTO  m004
			;				index=0;
	CLRF  index
			;				neg=0;
	BCF   0x24,neg
			;				change=1;
	BSF   0x24,change
			;			}
			;		}
			;		else{
	GOTO  m004
			;			CCPR2L=SPWMTAB(index);
m002	BCF   0x03,RP0
	MOVF  index,W
	CALL  SPWMTAB
	BCF   0x03,RP0
	MOVWF CCPR2L
			;			if(change){
	BTFSS 0x24,change
	GOTO  m003
			;//				while(PWMLR);
			;				PWMHL=0;
	BCF   0x07,PWMHL
			;				PWMLR=0;
	BCF   0x07,PWMLR
			;				CCP1CON=0;
	CLRF  CCP1CON
			;				CCP2CON=0xc;
	MOVLW .12
	MOVWF CCP2CON
			;				PWMHR=1;
	BSF   0x07,PWMHR
			;				change=0;
	BCF   0x24,change
			;			}
			;			index++;
m003	BCF   0x03,RP0
	INCF  index,1
			;			if(index==SPWMCOUNT){
	MOVF  index,W
	XORLW .150
	BTFSS 0x03,Zero_
	GOTO  m004
			;				index=0;
	CLRF  index
			;				neg=1;
	BSF   0x24,neg
			;				change=1;
	BSF   0x24,change
			;			}
			;		}
			;		TMR2IF=0;
m004	BCF   0x03,RP0
	BCF   0x0C,TMR2IF
			;	}
			;				
			;    	int_restore_registers // W, STATUS (and PCLATH)
m005	BCF   0x03,RP0
	MOVF  s3,W
	MOVWF PCLATH
	SWAPF s2,W
	MOVWF STATUS
	SWAPF s1_save,1
	SWAPF s1_save,W
			;}
	RETFIE
			;
			;void main(void)
			;{
main
			;
			;//	PORT CONFIGRATION
			;	
			;	TRISB=0xf;
	MOVLW .15
	BSF   0x03,RP0
	MOVWF TRISB
			;	PORTC=0;
	BCF   0x03,RP0
	CLRF  PORTC
			;	TRISC=0xf0;
	MOVLW .240
	BSF   0x03,RP0
	MOVWF TRISC
			;	
			;//	PWM OUTPUT CONFIGRATION
			;	
			;	neg=0;
	BCF   0x03,RP0
	BCF   0x24,neg
			;	front=1;
	BSF   0x24,front
			;	index=0;
	CLRF  index
			;	CCPR1L=0;
	CLRF  CCPR1L
			;	CCPR2L=0;
	CLRF  CCPR2L
			;	PR2=66;	//PERIORD
	MOVLW .66
	BSF   0x03,RP0
	MOVWF PR2
			;//	CCP1CON=0xc;
			;	CCP2CON=0xc;
	MOVLW .12
	BCF   0x03,RP0
	MOVWF CCP2CON
			;	TMR2IE=1;
	BSF   0x03,RP0
	BSF   0x0C,TMR2IE
			;	T2CON=4;
	MOVLW .4
	BCF   0x03,RP0
	MOVWF T2CON
			;	PEIE=1;
	BSF   0x0B,PEIE
			;	GIE=1;
	BSF   0x0B,GIE
			;	while(1);
m006	GOTO  m006
			;}
			;
			;//***********************************************
			;//     SPWM DATA TAB                            
			;//     Generate by SPWMGEN V1.0                 
			;//     Author:Fengjiantao                       
			;//     http://fjt.yeah.net                      
			;//     Email:fjt@371.net                        
			;//     Carrier Index:300
			;//     Modulation Index:90
			;//     Pluse number:67
			;//     MODE:Ë«¼«ÐÔ
			;//************************************************
			;unsigned char SPWMTAB(unsigned char tabindex)
			;{
SPWMTAB
	BCF   0x03,RP0
	MOVWF tabindex
			;     PCL+=W;
	ADDWF PCL,1
			;          return 33;
	RETLW .33
			;          return 34;
	RETLW .34
			;          return 35;
	RETLW .35
			;          return 35;
	RETLW .35
			;          return 36;
	RETLW .36
			;          return 36;
	RETLW .36
			;          return 37;
	RETLW .37
			;          return 38;
	RETLW .38
			;          return 38;
	RETLW .38
			;          return 39;
	RETLW .39
			;          return 40;
	RETLW .40
			;          return 40;
	RETLW .40
			;          return 41;
	RETLW .41
			;          return 41;
	RETLW .41
			;          return 42;
	RETLW .42
			;          return 43;
	RETLW .43
			;          return 43;
	RETLW .43
			;          return 44;
	RETLW .44
			;          return 44;
	RETLW .44
			;          return 45;
	RETLW .45
			;          return 46;
	RETLW .46
			;          return 46;
	RETLW .46
			;          return 47;
	RETLW .47
			;          return 47;
	RETLW .47
			;          return 48;
	RETLW .48
			;          return 48;
	RETLW .48
			;          return 49;
	RETLW .49
			;          return 49;
	RETLW .49
			;          return 50;
	RETLW .50
			;          return 50;
	RETLW .50
			;          return 51;
	RETLW .51
			;          return 51;
	RETLW .51
			;          return 52;
	RETLW .52
			;          return 52;
	RETLW .52
			;          return 53;
	RETLW .53
			;          return 53;
	RETLW .53
			;          return 54;
	RETLW .54
			;          return 54;
	RETLW .54
			;          return 55;
	RETLW .55
			;          return 55;
	RETLW .55
			;          return 56;
	RETLW .56
			;          return 56;
	RETLW .56
			;          return 56;
	RETLW .56
			;          return 57;
	RETLW .57
			;          return 57;
	RETLW .57
			;          return 58;
	RETLW .58
			;          return 58;
	RETLW .58
			;          return 58;
	RETLW .58
			;          return 59;
	RETLW .59
			;          return 59;
	RETLW .59
			;          return 59;
	RETLW .59
			;          return 60;
	RETLW .60
			;          return 60;
	RETLW .60
			;          return 60;
	RETLW .60
			;          return 60;
	RETLW .60
			;          return 61;
	RETLW .61
			;          return 61;
	RETLW .61
			;          return 61;
	RETLW .61
			;          return 61;
	RETLW .61
			;          return 62;
	RETLW .62
			;          return 62;
	RETLW .62
			;          return 62;
	RETLW .62
			;          return 62;
	RETLW .62
			;          return 62;
	RETLW .62
			;          return 62;
	RETLW .62
			;          return 63;
	RETLW .63
			;          return 63;
	RETLW .63
			;          return 63;
	RETLW .63
			;          return 63;
	RETLW .63
			;          return 63;
	RETLW .63
			;          return 63;
	RETLW .63
			;          return 63;
	RETLW .63
			;          return 63;
	RETLW .63
			;          return 63;
	RETLW .63
			;          return 63;
	RETLW .63
			;          return 63;
	RETLW .63
			;          return 63;
	RETLW .63
			;          return 63;
	RETLW .63
			;          return 63;
	RETLW .63
			;          return 63;
	RETLW .63
			;          return 63;
	RETLW .63
			;          return 63;
	RETLW .63
			;          return 63;
	RETLW .63
			;          return 63;
	RETLW .63
			;          return 63;
	RETLW .63
			;          return 62;
	RETLW .62
			;          return 62;
	RETLW .62
			;          return 62;
	RETLW .62
			;          return 62;
	RETLW .62
			;          return 62;
	RETLW .62
			;          return 62;
	RETLW .62
			;          return 61;
	RETLW .61
			;          return 61;
	RETLW .61
			;          return 61;
	RETLW .61
			;          return 61;
	RETLW .61
			;          return 60;
	RETLW .60
			;          return 60;
	RETLW .60
			;          return 60;
	RETLW .60
			;          return 60;
	RETLW .60
			;          return 59;
	RETLW .59
			;          return 59;
	RETLW .59
			;          return 59;
	RETLW .59
			;          return 58;
	RETLW .58
			;          return 58;
	RETLW .58
			;          return 58;
	RETLW .58
			;          return 57;
	RETLW .57
			;          return 57;
	RETLW .57
			;          return 56;
	RETLW .56
			;          return 56;
	RETLW .56
			;          return 56;
	RETLW .56
			;          return 55;
	RETLW .55
			;          return 55;
	RETLW .55
			;          return 54;
	RETLW .54
			;          return 54;
	RETLW .54
			;          return 53;
	RETLW .53
			;          return 53;
	RETLW .53
			;          return 52;
	RETLW .52
			;          return 52;
	RETLW .52
			;          return 51;
	RETLW .51
			;          return 51;
	RETLW .51
			;          return 50;
	RETLW .50
			;          return 50;
	RETLW .50
			;          return 49;
	RETLW .49
			;          return 49;
	RETLW .49
			;          return 48;
	RETLW .48
			;          return 48;
	RETLW .48
			;          return 47;
	RETLW .47
			;          return 47;
	RETLW .47
			;          return 46;
	RETLW .46
			;          return 46;
	RETLW .46
			;          return 45;
	RETLW .45
			;          return 44;
	RETLW .44
			;          return 44;
	RETLW .44
			;          return 43;
	RETLW .43
			;          return 43;
	RETLW .43
			;          return 42;
	RETLW .42
			;          return 41;
	RETLW .41
			;          return 41;
	RETLW .41
			;          return 40;
	RETLW .40
			;          return 40;
	RETLW .40
			;          return 39;
	RETLW .39
			;          return 38;
	RETLW .38
			;          return 38;
	RETLW .38
			;          return 37;
	RETLW .37
			;          return 36;
	RETLW .36
			;          return 36;
	RETLW .36
			;          return 35;
	RETLW .35
			;          return 35;
	RETLW .35
			;          return 34;
	RETLW .34
			;          return 33;
	RETLW .33

	END
