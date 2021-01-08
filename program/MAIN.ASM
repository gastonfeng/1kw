
; CC5X Version 3.1C, Copyright (c) B Knudsen Data
; C compiler for the PICmicro family
; ************   6. Jun 2001   0:50  *************

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
PWMHL       EQU   3
s1_save     EQU   0x20
s2          EQU   0x21
s3          EQU   0x22
tabindex    EQU   0x23
tabindex_2  EQU   0x23

	GOTO main

  ; FILE D:\PRODUCT\1KW\PROGRAM\MAIN.C
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
			;#define SPWMCOUNT 29
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
			;unsigned char PEIRODTAB(unsigned char tabindex);
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
			;	PR2=PEIRODTAB(index);
	MOVF  index,W
	CALL  PEIRODTAB
	BSF   0x03,RP0
	MOVWF PR2
			;	if(TMR2IF){
	BCF   0x03,RP0
	BTFSS 0x0C,TMR2IF
	GOTO  m011
			;		if(neg){
	BTFSS 0x24,neg
	GOTO  m005
			;			CCPR1L=SPWMTAB(index);
	MOVF  index,W
	CALL  SPWMTAB
	BCF   0x03,RP0
	MOVWF CCPR1L
			;			if(change){
	BTFSS 0x24,change
	GOTO  m001
			;				PWMHR=0;
	BCF   0x07,PWMHR
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
			;			if(front){
m001	BCF   0x03,RP0
	BTFSS 0x24,front
	GOTO  m003
			;				if(index==SPWMCOUNT){
	MOVF  index,W
	XORLW .29
	BTFSS 0x03,Zero_
	GOTO  m002
			;					front=0;
	BCF   0x24,front
			;				}
			;				else index++;
	GOTO  m010
m002	BCF   0x03,RP0
	INCF  index,1
			;			}
			;			else{
	GOTO  m010
			;				if(index==0){
m003	BCF   0x03,RP0
	MOVF  index,1
	BTFSS 0x03,Zero_
	GOTO  m004
			;					front=1;
	BSF   0x24,front
			;					neg=0;
	BCF   0x24,neg
			;					change=1;
	BSF   0x24,change
			;					//PWMHL=0;
			;					//CCP1CON=0;
			;					//CCP2CON=0xc;
			;					//PWMHR=1;
			;				}
			;				else index--;
	GOTO  m010
m004	BCF   0x03,RP0
	DECF  index,1
			;			}
			;		}
			;		else{
	GOTO  m010
			;			CCPR2L=SPWMTAB(index);
m005	BCF   0x03,RP0
	MOVF  index,W
	CALL  SPWMTAB
	BCF   0x03,RP0
	MOVWF CCPR2L
			;			if(change){
	BTFSS 0x24,change
	GOTO  m006
			;				PWMHL=0;
	BCF   0x07,PWMHL
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
			;			if(front){
m006	BCF   0x03,RP0
	BTFSS 0x24,front
	GOTO  m008
			;				if(index==SPWMCOUNT){
	MOVF  index,W
	XORLW .29
	BTFSS 0x03,Zero_
	GOTO  m007
			;					front=0;
	BCF   0x24,front
			;				}
			;				else index++;
	GOTO  m010
m007	BCF   0x03,RP0
	INCF  index,1
			;			}
			;			else{
	GOTO  m010
			;				if(index==0){
m008	BCF   0x03,RP0
	MOVF  index,1
	BTFSS 0x03,Zero_
	GOTO  m009
			;					front=1;
	BSF   0x24,front
			;					neg=1;
	BSF   0x24,neg
			;					change=1;
	BSF   0x24,change
			;					//PWMHR=0;
			;					//CCP2CON=0;
			;					//CCP1CON=0xc;
			;					//PWMHL=1;
			;				}
			;				else index--;
	GOTO  m010
m009	BCF   0x03,RP0
	DECF  index,1
			;			}
			;		}
			;		TMR2IF=0;
m010	BCF   0x03,RP0
	BCF   0x0C,TMR2IF
			;	}
			;				
			;    	int_restore_registers // W, STATUS (and PCLATH)
m011	BCF   0x03,RP0
	MOVF  s3,W
	MOVWF PCLATH
	SWAPF s2,W
	MOVWF STATUS
	SWAPF s1_save,1
	SWAPF s1_save,W
			;}
	RETFIE
			;
			;//***********************************************
			;//     SPWM DATA TAB                            
			;//     Generate by SPWMGEN V1.0                 
			;//     Author:Fengjiantao                       
			;//     http://fjt.yeah.net                      
			;//     Email:fjt@371.net                        
			;//     Carrier Index:120
			;//     Modulation Index:80
			;//     Pluse number:167
			;//     MODE:µ¥¼«ÐÔ
			;//************************************************
			;unsigned char SPWMTAB(unsigned char tabindex)
			;{
SPWMTAB
	BCF   0x03,RP0
	MOVWF tabindex
			;     PCL+=W;
	ADDWF PCL,1
			;          return 3;
	RETLW .3
			;          return 10;
	RETLW .10
			;          return 17;
	RETLW .17
			;          return 24;
	RETLW .24
			;          return 31;
	RETLW .31
			;          return 37;
	RETLW .37
			;          return 44;
	RETLW .44
			;          return 51;
	RETLW .51
			;          return 57;
	RETLW .57
			;          return 63;
	RETLW .63
			;          return 69;
	RETLW .69
			;          return 75;
	RETLW .75
			;          return 81;
	RETLW .81
			;          return 86;
	RETLW .86
			;          return 91;
	RETLW .91
			;          return 96;
	RETLW .96
			;          return 101;
	RETLW .101
			;          return 105;
	RETLW .105
			;          return 110;
	RETLW .110
			;          return 113;
	RETLW .113
			;          return 117;
	RETLW .117
			;          return 120;
	RETLW .120
			;          return 123;
	RETLW .123
			;          return 125;
	RETLW .125
			;          return 128;
	RETLW .128
			;          return 129;
	RETLW .129
			;          return 131;
	RETLW .131
			;          return 132;
	RETLW .132
			;          return 133;
	RETLW .133
			;          return 133;
	RETLW .133
			;}
			;
			;unsigned char PEIRODTAB(unsigned char tabindex)
			;{
PEIRODTAB
	BCF   0x03,RP0
	MOVWF tabindex_2
			;     PCL+=W;
	ADDWF PCL,1
			;          return 166;
	RETLW .166
			;          return 170;
	RETLW .170
			;          return 170;
	RETLW .170
			;          return 170;
	RETLW .170
			;          return 170;
	RETLW .170
			;          return 170;
	RETLW .170
			;          return 170;
	RETLW .170
			;          return 170;
	RETLW .170
			;          return 170;
	RETLW .170
			;          return 170;
	RETLW .170
			;          return 170;
	RETLW .170
			;          return 169;
	RETLW .169
			;          return 169;
	RETLW .169
			;          return 169;
	RETLW .169
			;          return 169;
	RETLW .169
			;          return 169;
	RETLW .169
			;          return 169;
	RETLW .169
			;          return 169;
	RETLW .169
			;          return 169;
	RETLW .169
			;          return 168;
	RETLW .168
			;          return 168;
	RETLW .168
			;          return 168;
	RETLW .168
			;          return 168;
	RETLW .168
			;          return 168;
	RETLW .168
			;          return 168;
	RETLW .168
			;          return 167;
	RETLW .167
			;          return 167;
	RETLW .167
			;          return 167;
	RETLW .167
			;          return 167;
	RETLW .167
			;          return 167;
	RETLW .167
			;}
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
			;	PR2=0xa6;	//PERIORD
	MOVLW .166
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
m012	GOTO  m012

	END
