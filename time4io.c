#include <stdint.h>
#include <pic32mx.h>
#include "mipslab.h" 

int getsw(){
  return ((PORTD>>8) & 0x000f); // SW4 through SW1 are connected to bits 11 through 8 
}

int getbtns(){
  return ((PORTD>>5) & 0x0007); //5,6,7
}