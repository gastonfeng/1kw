/**********************************************
*	Filename:	main.c
*	Project:	2k1.pjt
*	Product name:	1kW sin waveform inverter
***********************************************
*
*	Author:		Feng Jiantao
*	Date:		2001.01.22
*	Compiled Using CC5Xfree package
*
**********************************************/

#include <16C73A.H>
#include <int16cxx.H>

#define SPWMCOUNT 150

#define LVD	200
#define PRESET	200

unsigned char index;

#pragma bit OUTHR @ 7.0
#pragma bit PWM2 @ 7.1		//CCP2
#pragma bit PWM1 @ 7.2		//CCP1
#pragma bit OUTHL @ 7.3

#pragma bit LED_POWER	@  6.4
#pragma bit LED_LVD	@ 6.5
#pragma bit LED_PROTECT	@ 6.6
#pragma bit LED_WORK	@ 6.7

unsigned char SPWMTAB(unsigned char tabindex);

#pragma origin = 4

interrupt int_server( void)
{
	unsigned char pwmvalue;
    	int_save_registers    // W, STATUS (and PCLATH)
	if(TMR2IF){
		pwmvalue=SPWMTAB(index);
		CCPR1L=pwmvalue+1;
		CCPR2L=pwmvalue+2;
		index++;
		if(index==SPWMCOUNT){
			index=0;
		}
		TMR2IF=0;
	}
				
    	int_restore_registers // W, STATUS (and PCLATH)
}

//***********************************************
//     SPWM DATA TAB                            
//     Generate by SPWMGEN V1.0                 
//     Author:Fengjiantao                       
//     http://fjt.yeah.net                      
//     Email:fjt@371.net                        
//     Carrier Index:150
//     Modulation Index:95
//     Pluse number:133
//     MODE:Ë«¼«ÐÔ
//************************************************
unsigned char SPWMTAB(unsigned char tabindex)
{
     PCL+=W;
          return 67;
          return 70;
          return 73;
          return 75;
          return 78;
          return 80;
          return 83;
          return 86;
          return 88;
          return 90;
          return 93;
          return 95;
          return 98;
          return 100;
          return 102;
          return 104;
          return 106;
          return 108;
          return 110;
          return 112;
          return 114;
          return 116;
          return 117;
          return 119;
          return 120;
          return 121;
          return 123;
          return 124;
          return 125;
          return 126;
          return 126;
          return 127;
          return 128;
          return 128;
          return 129;
          return 129;
          return 129;
          return 129;
          return 129;
          return 129;
          return 129;
          return 128;
          return 128;
          return 127;
          return 126;
          return 126;
          return 125;
          return 124;
          return 123;
          return 121;
          return 120;
          return 119;
          return 117;
          return 116;
          return 114;
          return 112;
          return 110;
          return 108;
          return 106;
          return 104;
          return 102;
          return 100;
          return 98;
          return 95;
          return 93;
          return 90;
          return 88;
          return 86;
          return 83;
          return 80;
          return 78;
          return 75;
          return 73;
          return 70;
          return 67;
          return 65;
          return 62;
          return 59;
          return 57;
          return 54;
          return 52;
          return 49;
          return 46;
          return 44;
          return 42;
          return 39;
          return 37;
          return 34;
          return 32;
          return 30;
          return 28;
          return 26;
          return 24;
          return 22;
          return 20;
          return 18;
          return 16;
          return 15;
          return 13;
          return 12;
          return 11;
          return 9;
          return 8;
          return 7;
          return 6;
          return 6;
          return 5;
          return 4;
          return 4;
          return 3;
          return 3;
          return 3;
          return 3;
          return 3;
          return 3;
          return 3;
          return 4;
          return 4;
          return 5;
          return 6;
          return 6;
          return 7;
          return 8;
          return 9;
          return 11;
          return 12;
          return 13;
          return 15;
          return 16;
          return 18;
          return 20;
          return 22;
          return 24;
          return 26;
          return 28;
          return 30;
          return 32;
          return 34;
          return 37;
          return 39;
          return 42;
          return 44;
          return 46;
          return 49;
          return 52;
          return 54;
          return 57;
          return 59;
          return 62;
          return 65;
}

void main(void)
{
	union{
		unsigned long s16;
		char s8[2];
	}sum;
	char i;

//	PORT CONFIGRATION
	
	TRISB=0xf;
	PORTC=0;
	TRISC=0xf0;
	LED_POWER=1;
	LED_LVD=0;
	LED_WORK=0;
	LED_PROTECT=0;

//	Analog/Digital Converter Configuration
	
	ADCON1=0;
	
//	PWM OUTPUT CONFIGURATION
	
	index=0;
	CCPR1L=0;
	CCPR2L=0;
	PR2=132;	//PERIORD
	CCP1CON=0xc;
	CCP2CON=0xc;
	TMR2IE=1;
	T2CON=4;
	PEIE=1;
	ADIE=0;
	GIE=1;
	
	LED_WORK=1;
	
	while(1){
		sum.s16=0;
		ADCON0=0x81;
		clrwdt();
		clrwdt();
		clrwdt();
		clrwdt();
		i=0;
		do{
			clrwdt();
			clrwdt();
			clrwdt();
			clrwdt();
			GO=1;
			while(GO);
			sum.s16+=ADRES;
			i++;
		}while(i!=0);
		if(sum.s8[1]<LVD){
//			GIE=0;
//			CCP1CON=0;
//			PWM1=0;
//			CCP2CON=0;
//			PWM2=1;
//			LED_WORK=0;
//			LED_LVD=1;
//			while(1);
		}
		sum.s16=0;
		ADCON0=0x91;
		clrwdt();
		clrwdt();
		clrwdt();
		clrwdt();
		i=0;
		do{
			clrwdt();
			clrwdt();
			clrwdt();
			clrwdt();
//			GO=1;
//			while(GO);
			sum.s16+=ADRES;
			i++;
		}while(i!=0);
		if(sum.s8[1]>PRESET){
			GIE=0;
//			CCP1CON=0;
//			PWM1=0;
//			CCP2CON=0;
//			PWM2=1;
//			LED_WORK=0;
//			LED_PROTECT=1;
//			while(1);
		}
	}
}


