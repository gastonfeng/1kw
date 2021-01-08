
; CC5X Version 3.1C, Copyright (c) B Knudsen Data
; C compiler for the PICmicro family
; ************  21. Jun 2001  17:35  *************

	processor  16C73A
	radix  DEC

PCL         EQU   0x02
STATUS      EQU   0x03
TRISB       EQU   0x86
PCLATH      EQU   0x0A
Carry       EQU   0
Zero_       EQU   2
RP0         EQU   5
GIE         EQU   7
PORTC       EQU   0x07
T2CON       EQU   0x12
CCPR1L      EQU   0x15
CCP1CON     EQU   0x17
CCPR2L      EQU   0x1B
CCP2CON     EQU   0x1D
ADRES       EQU   0x1E
ADCON0      EQU   0x1F
TRISC       EQU   0x87
PR2         EQU   0x92
ADCON1      EQU   0x9F
PEIE        EQU   6
TMR2IF      EQU   1
GO          EQU   2
TMR2IE      EQU   1
ADIE        EQU   6
index       EQU   0x28
LED_POWER   EQU   4
LED_LVD     EQU   5
LED_PROTECT EQU   6
LED_WORK    EQU   7
pwmvalue    EQU   0x21
s1_save     EQU   0x20
s2          EQU   0x22
s3          EQU   0x23
tabindex    EQU   0x24
sum         EQU   0x25
i           EQU   0x27

	GOTO main

  ; FILE D:\PRODUCT\1KW\PROGRAM\DBL.C
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
			;#include <16C73A.H>
			;#include <int16cxx.H>
			;
			;#define SPWMCOUNT 150
			;
			;#define LVD	200
			;#define PRESET	200
			;
			;unsigned char index;
			;
			;#pragma bit OUTHR @ 7.0
			;#pragma bit PWM2 @ 7.1		//CCP2
			;#pragma bit PWM1 @ 7.2		//CCP1
			;#pragma bit OUTHL @ 7.3
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
			;	unsigned char pwmvalue;
			;    	int_save_registers    // W, STATUS (and PCLATH)
	MOVWF s1_save
	SWAPF STATUS,W
	BCF   0x03,RP0
	MOVWF s2
	MOVF  PCLATH,W
	MOVWF s3
	CLRF  PCLATH
			;	if(TMR2IF){
	BTFSS 0x0C,TMR2IF
	GOTO  m001
			;		pwmvalue=SPWMTAB(index);
	MOVF  index,W
	CALL  SPWMTAB
	BCF   0x03,RP0
	MOVWF pwmvalue
			;		CCPR1L=pwmvalue+1;
	INCF  pwmvalue,W
	MOVWF CCPR1L
			;		CCPR2L=pwmvalue+2;
	MOVLW .2
	ADDWF pwmvalue,W
	MOVWF CCPR2L
			;		index++;
	INCF  index,1
			;		if(index==SPWMCOUNT){
	MOVF  index,W
	XORLW .150
	BTFSC 0x03,Zero_
			;			index=0;
	CLRF  index
			;		}
			;		TMR2IF=0;
	BCF   0x03,RP0
	BCF   0x0C,TMR2IF
			;	}
			;				
			;    	int_restore_registers // W, STATUS (and PCLATH)
m001	BCF   0x03,RP0
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
			;//     Carrier Index:150
			;//     Modulation Index:95
			;//     Pluse number:133
			;//     MODE:Ë«¼«ÐÔ
			;//************************************************
			;unsigned char SPWMTAB(unsigned char tabindex)
			;{
SPWMTAB
	BCF   0x03,RP0
	MOVWF tabindex
			;     PCL+=W;
	ADDWF PCL,1
			;          return 67;
	RETLW .67
			;          return 70;
	RETLW .70
			;          return 73;
	RETLW .73
			;          return 75;
	RETLW .75
			;          return 78;
	RETLW .78
			;          return 80;
	RETLW .80
			;          return 83;
	RETLW .83
			;          return 86;
	RETLW .86
			;          return 88;
	RETLW .88
			;          return 90;
	RETLW .90
			;          return 93;
	RETLW .93
			;          return 95;
	RETLW .95
			;          return 98;
	RETLW .98
			;          return 100;
	RETLW .100
			;          return 102;
	RETLW .102
			;          return 104;
	RETLW .104
			;          return 106;
	RETLW .106
			;          return 108;
	RETLW .108
			;          return 110;
	RETLW .110
			;          return 112;
	RETLW .112
			;          return 114;
	RETLW .114
			;          return 116;
	RETLW .116
			;          return 117;
	RETLW .117
			;          return 119;
	RETLW .119
			;          return 120;
	RETLW .120
			;          return 121;
	RETLW .121
			;          return 123;
	RETLW .123
			;          return 124;
	RETLW .124
			;          return 125;
	RETLW .125
			;          return 126;
	RETLW .126
			;          return 126;
	RETLW .126
			;          return 127;
	RETLW .127
			;          return 128;
	RETLW .128
			;          return 128;
	RETLW .128
			;          return 129;
	RETLW .129
			;          return 129;
	RETLW .129
			;          return 129;
	RETLW .129
			;          return 129;
	RETLW .129
			;          return 129;
	RETLW .129
			;          return 129;
	RETLW .129
			;          return 129;
	RETLW .129
			;          return 128;
	RETLW .128
			;          return 128;
	RETLW .128
			;          return 127;
	RETLW .127
			;          return 126;
	RETLW .126
			;          return 126;
	RETLW .126
			;          return 125;
	RETLW .125
			;          return 124;
	RETLW .124
			;          return 123;
	RETLW .123
			;          return 121;
	RETLW .121
			;          return 120;
	RETLW .120
			;          return 119;
	RETLW .119
			;          return 117;
	RETLW .117
			;          return 116;
	RETLW .116
			;          return 114;
	RETLW .114
			;          return 112;
	RETLW .112
			;          return 110;
	RETLW .110
			;          return 108;
	RETLW .108
			;          return 106;
	RETLW .106
			;          return 104;
	RETLW .104
			;          return 102;
	RETLW .102
			;          return 100;
	RETLW .100
			;          return 98;
	RETLW .98
			;          return 95;
	RETLW .95
			;          return 93;
	RETLW .93
			;          return 90;
	RETLW .90
			;          return 88;
	RETLW .88
			;          return 86;
	RETLW .86
			;          return 83;
	RETLW .83
			;          return 80;
	RETLW .80
			;          return 78;
	RETLW .78
			;          return 75;
	RETLW .75
			;          return 73;
	RETLW .73
			;          return 70;
	RETLW .70
			;          return 67;
	RETLW .67
			;          return 65;
	RETLW .65
			;          return 62;
	RETLW .62
			;          return 59;
	RETLW .59
			;          return 57;
	RETLW .57
			;          return 54;
	RETLW .54
			;          return 52;
	RETLW .52
			;          return 49;
	RETLW .49
			;          return 46;
	RETLW .46
			;          return 44;
	RETLW .44
			;          return 42;
	RETLW .42
			;          return 39;
	RETLW .39
			;          return 37;
	RETLW .37
			;          return 34;
	RETLW .34
			;          return 32;
	RETLW .32
			;          return 30;
	RETLW .30
			;          return 28;
	RETLW .28
			;          return 26;
	RETLW .26
			;          return 24;
	RETLW .24
			;          return 22;
	RETLW .22
			;          return 20;
	RETLW .20
			;          return 18;
	RETLW .18
			;          return 16;
	RETLW .16
			;          return 15;
	RETLW .15
			;          return 13;
	RETLW .13
			;          return 12;
	RETLW .12
			;          return 11;
	RETLW .11
			;          return 9;
	RETLW .9
			;          return 8;
	RETLW .8
			;          return 7;
	RETLW .7
			;          return 6;
	RETLW .6
			;          return 6;
	RETLW .6
			;          return 5;
	RETLW .5
			;          return 4;
	RETLW .4
			;          return 4;
	RETLW .4
			;          return 3;
	RETLW .3
			;          return 3;
	RETLW .3
			;          return 3;
	RETLW .3
			;          return 3;
	RETLW .3
			;          return 3;
	RETLW .3
			;          return 3;
	RETLW .3
			;          return 3;
	RETLW .3
			;          return 4;
	RETLW .4
			;          return 4;
	RETLW .4
			;          return 5;
	RETLW .5
			;          return 6;
	RETLW .6
			;          return 6;
	RETLW .6
			;          return 7;
	RETLW .7
			;          return 8;
	RETLW .8
			;          return 9;
	RETLW .9
			;          return 11;
	RETLW .11
			;          return 12;
	RETLW .12
			;          return 13;
	RETLW .13
			;          return 15;
	RETLW .15
			;          return 16;
	RETLW .16
			;          return 18;
	RETLW .18
			;          return 20;
	RETLW .20
			;          return 22;
	RETLW .22
			;          return 24;
	RETLW .24
			;          return 26;
	RETLW .26
			;          return 28;
	RETLW .28
			;          return 30;
	RETLW .30
			;          return 32;
	RETLW .32
			;          return 34;
	RETLW .34
			;          return 37;
	RETLW .37
			;          return 39;
	RETLW .39
			;          return 42;
	RETLW .42
			;          return 44;
	RETLW .44
			;          return 46;
	RETLW .46
			;          return 49;
	RETLW .49
			;          return 52;
	RETLW .52
			;          return 54;
	RETLW .54
			;          return 57;
	RETLW .57
			;          return 59;
	RETLW .59
			;          return 62;
	RETLW .62
			;          return 65;
	RETLW .65
			;}
			;
			;void main(void)
			;{
main
			;	union{
			;		unsigned long s16;
			;		char s8[2];
			;	}sum;
			;	char i;
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
			;	LED_POWER=1;
	BCF   0x03,RP0
	BSF   0x06,LED_POWER
			;	LED_LVD=0;
	BCF   0x06,LED_LVD
			;	LED_WORK=0;
	BCF   0x06,LED_WORK
			;	LED_PROTECT=0;
	BCF   0x06,LED_PROTECT
			;
			;//	Analog/Digital Converter Configuration
			;	
			;	ADCON1=0;
	BSF   0x03,RP0
	CLRF  ADCON1
			;	
			;//	PWM OUTPUT CONFIGURATION
			;	
			;	index=0;
	BCF   0x03,RP0
	CLRF  index
			;	CCPR1L=0;
	CLRF  CCPR1L
			;	CCPR2L=0;
	CLRF  CCPR2L
			;	PR2=132;	//PERIORD
	MOVLW .132
	BSF   0x03,RP0
	MOVWF PR2
			;	CCP1CON=0xc;
	MOVLW .12
	BCF   0x03,RP0
	MOVWF CCP1CON
			;	CCP2CON=0xc;
	MOVLW .12
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
			;	ADIE=0;
	BSF   0x03,RP0
	BCF   0x0C,ADIE
			;	GIE=1;
	BSF   0x0B,GIE
			;	
			;	LED_WORK=1;
	BCF   0x03,RP0
	BSF   0x06,LED_WORK
			;	
			;	while(1){
			;		sum.s16=0;
m002	BCF   0x03,RP0
	CLRF  sum
	CLRF  sum+1
			;		ADCON0=0x81;
	MOVLW .129
	MOVWF ADCON0
			;		clrwdt();
	CLRWDT
			;		clrwdt();
	CLRWDT
			;		clrwdt();
	CLRWDT
			;		clrwdt();
	CLRWDT
			;		i=0;
	CLRF  i
			;		do{
			;			clrwdt();
m003	CLRWDT
			;			clrwdt();
	CLRWDT
			;			clrwdt();
	CLRWDT
			;			clrwdt();
	CLRWDT
			;			GO=1;
	BCF   0x03,RP0
	BSF   0x1F,GO
			;			while(GO);
m004	BCF   0x03,RP0
	BTFSC 0x1F,GO
	GOTO  m004
			;			sum.s16+=ADRES;
	BCF   0x03,RP0
	MOVF  ADRES,W
	ADDWF sum,1
	BTFSC 0x03,Carry
	INCF  sum+1,1
			;			i++;
	INCFSZ i,1
			;		}while(i!=0);
	GOTO  m003
			;		if(sum.s8[1]<LVD){
	MOVLW .200
	SUBWF sum+1,W
	BTFSC 0x03,Carry
	GOTO  m005
			;//			GIE=0;
			;//			CCP1CON=0;
			;//			PWM1=0;
			;//			CCP2CON=0;
			;//			PWM2=1;
			;//			LED_WORK=0;
			;//			LED_LVD=1;
			;//			while(1);
			;		}
			;		sum.s16=0;
m005	BCF   0x03,RP0
	CLRF  sum
	CLRF  sum+1
			;		ADCON0=0x91;
	MOVLW .145
	MOVWF ADCON0
			;		clrwdt();
	CLRWDT
			;		clrwdt();
	CLRWDT
			;		clrwdt();
	CLRWDT
			;		clrwdt();
	CLRWDT
			;		i=0;
	CLRF  i
			;		do{
			;			clrwdt();
m006	CLRWDT
			;			clrwdt();
	CLRWDT
			;			clrwdt();
	CLRWDT
			;			clrwdt();
	CLRWDT
			;//			GO=1;
			;//			while(GO);
			;			sum.s16+=ADRES;
	BCF   0x03,RP0
	MOVF  ADRES,W
	ADDWF sum,1
	BTFSC 0x03,Carry
	INCF  sum+1,1
			;			i++;
	INCFSZ i,1
			;		}while(i!=0);
	GOTO  m006
			;		if(sum.s8[1]>PRESET){
	MOVLW .201
	SUBWF sum+1,W
	BTFSS 0x03,Carry
	GOTO  m002
			;			GIE=0;
	BCF   0x0B,GIE
			;//			CCP1CON=0;
			;//			PWM1=0;
			;//			CCP2CON=0;
			;//			PWM2=1;
			;//			LED_WORK=0;
			;//			LED_PROTECT=1;
			;//			while(1);
			;		}
			;	}
	GOTO  m002

	END
