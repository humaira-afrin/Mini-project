/* mipslabwork.c

   This file written 2015 by F Lundevall
   Updated 2017-04-21 by F Lundevall

   This file should be changed by YOU! So you must
   add comment(s) here with your name(s) and date(s):

   This file modified 2017-04-31 by Ture Teknolog 

   For copyright and licensing, see file COPYING */

#include <stdint.h>   /* Declarations of uint_32 and the like */
#include "pic32mx.h"  /* Declarations of system-specific addresses etc */
#include "mipslab.h"  /* Declatations for these labs */
#include <stdio.h>


int mytime = 0x5957;

char textstring[] = "text, more text, and even more text!";
volatile int *trisE;
volatile int *portE;
volatile int *portD;
volatile int *triseD;
volatile int *trisE = (volatile int*) 0xbf886100;
 volatile int *portE = (volatile int*) 0xbf886110;

int timeoutcount = 0; 
int count=0;


/* Interrupt Service Routine */
void user_isr( void )
{
     if(IFS(0) & 0x0100)
 { 
    timeoutcount++; 
    if(timeoutcount==10) //every 10th interupt
    {
        time2string( textstring, mytime );
        tick( &mytime );
        timeoutcount=0;
    }
    IFSCLR(0) = 0x100; 
 }
 //SW3
   if (IFS(0) & 0x8000) { 
	   T2CONCLR = 0x8000;
      IFSCLR(0) = 0x8000; 
   }
   //SW1
      if (IFS(0) & 0x80) { 
	   T2CON = 0x8070; 
      IFSCLR(0) =  0x80; 
   }
}


/* Lab-specific initialization goes here */
void labinit( void )
{
  *trisE = *trisE & 0x00;
  TMR2 = 0; 
  PR2= ((80000000/256)/30); 
  //T2CON = 0x8070; 
  IEC(0) = 1 << 8;
  IPCSET(2) = 0x1F;

/******************************************************************
 * ************************************/
/* SWITCH 3 */
  TRISDSET = 0x400; // Set bit 10 as input
  IECSET(0)=0x8000;
  IPC(3)=0x1F00; //bit 10-12 är priority

  /*SWTICH 1*/
  TRISDSET = 0x100; // Set bit  as input
  IECSET(0)=0x80;
  IPC(1)=0x1F000000;

  enable_interrupts(); 
  return;
}


/* This function is called repetitively from the main program */
void labwork( void )
{ int switches = getsw();
	int button = getbtns();

  if(button & 1)
  {
    	
     display_update();
     clearScreenMemory();
      drawBox(10, 0, 8, 8);
      merge(nybild,icon,triangle);
      display_image(1,nybild);
      delay(10);
      /*clearScreenMemory();
      drawBox(10, 20, 8, 8);
      display_update();
      merge(nybild,icon,triangle);
      display_image(1,nybild);*/

  }

  if(button & 2){
   clearScreenMemory();
   CountDown();
   T2CON = 0x8070; 
   display_update();
   }

   if (timeoutcount==1){ //every 10th interrupt , om 10 times per econ sätt timecount ==1
      display_update();
      clearScreenMemory();
      shiftTriangle(triangle);
      shiftTriangle(triangle1);

      drawBox(10, 25, 8, 8);
      merge(nybild, icon, triangle);
      display_image(1,nybild);
     timeoutcount =0; //reset
  }
  

   /*if (isGameOver(nybild)) 
    {
        //clearScreenMemory();
       T2CONCLR = 0x8000;
       display_update();
       display_string(0, "GAME OVER");
       display_string(2, "SCORE:");
       display_score(3, 42);
        
    }*/

  /*switch (gameState)
   {
   case 0:
      break;

   case 1:
      T2CONCLR = 0x8000;
      display_update();
      display_string(0, "GAME OVER");
      display_string(2, "SCORE:");
      break;
   }*/
}





