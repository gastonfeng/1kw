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

#define SPWMCOUNT 29

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
unsigned char PEIRODTAB(unsigned char tabindex);

#pragma origin = 4

interrupt int_server( void)
{
    	int_save_registers    // W, STATUS (and PCLATH)
	intflag=1;
	PR2=PEIRODTAB(index);
	if(TMR2IF){
		if(neg){
			CCPR1L=SPWMTAB(index);
			if(change){
				PWMHR=0;
				CCP2CON=0;
				CCP1CON=0xc;
				PWMHL=1;
				change=0;
			}
			if(front){
				if(index==SPWMCOUNT){
					front=0;
				}
				else index++;
			}
			else{
				if(index==0){
					front=1;
					neg=0;
					change=1;
					//PWMHL=0;
					//CCP1CON=0;
					//CCP2CON=0xc;
					//PWMHR=1;
				}
				else index--;
			}
		}
		else{
			CCPR2L=SPWMTAB(index);
			if(change){
				PWMHL=0;
				CCP1CON=0;
				CCP2CON=0xc;
				PWMHR=1;
				change=0;
			}
			if(front){
				if(index==SPWMCOUNT){
					front=0;
				}
				else index++;
			}
			else{
				if(index==0){
					front=1;
					neg=1;
					change=1;
					//PWMHR=0;
					//CCP2CON=0;
					//CCP1CON=0xc;
					//PWMHL=1;
				}
				else index--;
			}
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
//     Carrier Index:120
//     Modulation Index:80
//     Pluse number:167
//     MODE:µ¥¼«ÐÔ
//************************************************
unsigned char SPWMTAB(unsigned char tabindex)
{
     PCL+=W;
          return 3;
          return 10;
          return 17;
          return 24;
          return 31;
          return 37;
          return 44;
          return 51;
          return 57;
          return 63;
          return 69;
          return 75;
          return 81;
          return 86;
          return 91;
          return 96;
          return 101;
          return 105;
          return 110;
          return 113;
          return 117;
          return 120;
          return 123;
          return 125;
          return 128;
          return 129;
          return 131;
          return 132;
          return 133;
          return 133;
}

unsigned char PEIRODTAB(unsigned char tabindex)
{
     PCL+=W;
          return 166;
          return 170;
          return 170;
          return 170;
          return 170;
          return 170;
          return 170;
          return 170;
          return 170;
          return 170;
          return 170;
          return 169;
          return 169;
          return 169;
          return 169;
          return 169;
          return 169;
          return 169;
          return 169;
          return 168;
          return 168;
          return 168;
          return 168;
          return 168;
          return 168;
          return 167;
          return 167;
          return 167;
          return 167;
          return 167;
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
	PR2=0xa6;	//PERIORD
//	CCP1CON=0xc;
	CCP2CON=0xc;
	TMR2IE=1;
	T2CON=4;
	PEIE=1;
	GIE=1;
	while(1);
	
}
