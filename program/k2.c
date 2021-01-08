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

#define OPEN_LOOP
//#define	FEEDBACK

#define	F50Hz
//#define F60Hz

#include <16C73A.H>
#include <int16cxx.H>
//#include "spwmtab.C"

#define SPWMCOUNT 150

bit intflag,neg,front,change;
unsigned char index;

#pragma bit PWMHR @ 7.0
#pragma bit PWMLL @ 7.1		//CCP2
#pragma bit PWMLR @ 7.2		//CCP1
#pragma bit PWMHL @ 7.3

#pragma bit LED_POWER	@  6.4
#pragma bit LED_LVD	@ 6.5
#pragma bit LED_PROTECT	@ 6.6
#pragma bit LED_WORK	@ 6.7

unsigned char SPWMTAB(unsigned char tabindex);

#pragma origin = 4

interrupt int_server( void)
{
    	int_save_registers    // W, STATUS (and PCLATH)
	intflag=1;
	if(TMR2IF){
		if(neg){
			CCPR1L=SPWMTAB(index);
			if(change){
//				while(PWMLL);
				PWMHR=0;
				PWMLL=0;
				CCP2CON=0;
				CCP1CON=0xc;
				PWMHL=1;
				change=0;
			}
			index++;
			if(index==SPWMCOUNT){
				index=0;
				neg=0;
				change=1;
			}
		}
		else{
			CCPR2L=SPWMTAB(index);
			if(change){
//				while(PWMLR);
				PWMHL=0;
				PWMLR=0;
				CCP1CON=0;
				CCP2CON=0xc;
				PWMHR=1;
				change=0;
			}
			index++;
			if(index==SPWMCOUNT){
				index=0;
				neg=1;
				change=1;
			}
		}
		TMR2IF=0;
	}
				
    	int_restore_registers // W, STATUS (and PCLATH)
}

void main(void)
{

//	PORT CONFIGRATION
	
	TRISB=0xf;
	PORTC=0;
	TRISC=0xf0;
	
//	PWM OUTPUT CONFIGRATION
	
	neg=0;
	front=1;
	index=0;
	CCPR1L=0;
	CCPR2L=0;
	PR2=66;	//PERIORD
//	CCP1CON=0xc;
	CCP2CON=0xc;
	TMR2IE=1;
	T2CON=4;
	PEIE=1;
	GIE=1;
	while(1);
}

//***********************************************
//     SPWM DATA TAB                            
//     Generate by SPWMGEN V1.0                 
//     Author:Fengjiantao                       
//     http://fjt.yeah.net                      
//     Email:fjt@371.net                        
//     Carrier Index:300
//     Modulation Index:90
//     Pluse number:67
//     MODE:Ë«¼«ĞÔ
//************************************************
unsigned char SPWMTAB(unsigned char tabindex)
{
     PCL+=W;
          return 33;
          return 34;
          return 35;
          return 35;
          return 36;
          return 36;
          return 37;
          return 38;
          return 38;
          return 39;
          return 40;
          return 40;
          return 41;
          return 41;
          return 42;
          return 43;
          return 43;
          return 44;
          return 44;
          return 45;
          return 46;
          return 46;
          return 47;
          return 47;
          return 48;
          return 48;
          return 49;
          return 49;
          return 50;
          return 50;
          return 51;
          return 51;
          return 52;
          return 52;
          return 53;
          return 53;
          return 54;
          return 54;
          return 55;
          return 55;
          return 56;
          return 56;
          return 56;
          return 57;
          return 57;
          return 58;
          return 58;
          return 58;
          return 59;
          return 59;
          return 59;
          return 60;
          return 60;
          return 60;
          return 60;
          return 61;
          return 61;
          return 61;
          return 61;
          return 62;
          return 62;
          return 62;
          return 62;
          return 62;
          return 62;
          return 63;
          return 63;
          return 63;
          return 63;
          return 63;
          return 63;
          return 63;
          return 63;
          return 63;
          return 63;
          return 63;
          return 63;
          return 63;
          return 63;
          return 63;
          return 63;
          return 63;
          return 63;
          return 63;
          return 63;
          return 62;
          return 62;
          return 62;
          return 62;
          return 62;
          return 62;
          return 61;
          return 61;
          return 61;
          return 61;
          return 60;
          return 60;
          return 60;
          return 60;
          return 59;
          return 59;
          return 59;
          return 58;
          return 58;
          return 58;
          return 57;
          return 57;
          return 56;
          return 56;
          return 56;
          return 55;
          return 55;
          return 54;
          return 54;
          return 53;
          return 53;
          return 52;
          return 52;
          return 51;
          return 51;
          return 50;
          return 50;
          return 49;
          return 49;
          return 48;
          return 48;
          return 47;
          return 47;
          return 46;
          return 46;
          return 45;
          return 44;
          return 44;
          return 43;
          return 43;
          return 42;
          return 41;
          return 41;
          return 40;
          return 40;
          return 39;
          return 38;
          return 38;
          return 37;
          return 36;
          return 36;
          return 35;
          return 35;
          return 34;
          return 33;
}
