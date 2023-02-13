/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 05/02/2020
Author  : 
Company : 
Comments: 


Chip type               : ATtiny13
AVR Core Clock frequency: 9.600000 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 16
*****************************************************/

#include <tiny13.h>
#include <delay.h>

#define ADC_VREF_TYPE 0x20

// Read the 8 most significant bits
// of the AD conversion result
//unsigned char read_adc(unsigned char adc_input)
//{
//ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
//// Delay needed for the stabilization of the ADC input voltage
//delay_us(10);
//// Start the AD conversion
//ADCSRA|=0x40;
//// Wait for the AD conversion to complete
//while ((ADCSRA & 0x10)==0);
//ADCSRA|=0x10;
//return ADCH;
//}

// Declare your global variables here
void calc_pump_delay(void);
eeprom int save_delay;
eeprom int pump_delay;
eeprom char first_time_k;
void main(void)
{
// Declare your local variables here
 int i,exist,not_exist;

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port B initialization
// Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State5=T State4=T State3=T State2=T State1=T State0=T 
//PORTB=0x00;
//DDRB=0x00;

PORTB=0x00;
DDRB=0x07;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x00;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// External Interrupt(s) initialization
// INT0: Off
// Interrupt on any change on pins PCINT0-5: Off
GIMSK=0x00;
MCUCR=0x00;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
ACSR=0x80;
ADCSRB=0x00;
DIDR0=0x00;

// ADC initialization
// ADC Clock frequency: 75.000 kHz
// ADC Bandgap Voltage Reference: Off
// ADC Auto Trigger Source: Free Running
// Only the 8 most significant bits of
// the AD conversion result are used
// Digital input buffers on ADC0: Off, ADC1: On, ADC2: Off, ADC3: Off
DIDR0&=0x03;
DIDR0|=0x00;
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0xA7;
ADCSRB&=0xF8;


/////////////////////////////////////////
DDRB=0x07;
/////////////////////////////
PORTB.1 = 0; // pump
PORTB.0 = 1; // cheragh
PORTB.2 = 0; // sensor
exist = 0;
not_exist = 0;

if (first_time_k != 27)
{
save_delay = 2;
pump_delay = 550;
first_time_k = 27;
}

delay_ms(500); 
//////////////////////////

 calc_pump_delay();
 
DDRB=0x07;
while (1)
      {          
      
      //////////////////////
          
      
          PORTB.2 = 1; // sensor pulse
          delay_us(20);
          PORTB.2 = 0; 
          
          DDRB=0x03;    //pb.2 = input 
          
          while (!PINB.2)  
          {
          }; 
          
          i = 0;
          while (PINB.2)
          {
          i++;
          delay_us(10);
          };
          
        
          DDRB=0x07;   //pb.2 = output
              
          if (i<100) // ›«’·Â
          {
          if (exist <= 2) exist ++;  // «ê— œÊ »«— Å‘  ”— Â„ ”‰”Ê—  ‘ŒÌ’ Õ÷Ê— œ«œ ⁄„· ò‰œ
          
              
              if (exist == 2)  
              { 
              not_exist = 0;    
              
              /////////wash hands///////////
               PORTB.0 = 0; //led
               PORTB.1 = 1; //pump     
               delay_ms(pump_delay);   // relay pulse delay
               PORTB.1 = 0; 
               PORTB.0 = 1;
              //////////////////////////////
               delay_ms(100);
              } 
          
                    
          } 
          
          if (i>=100)  // ›«’·Â
          { 
          if (not_exist <= 2) not_exist ++;
          if (not_exist == 2)
          { 
          exist = 0; 
          }
          }
          
 delay_ms(100);         

//       
/////////////////////////////////
       

      }
};
//

 void calc_pump_delay(void)
 {
 int h,s; 
 
h = 0;
DDRB=0x07;
 
 while (h<100) 
 { 
      
          PORTB.2 = 1; // sensor pulse
          delay_us(20);
          PORTB.2 = 0; 
          
          DDRB=0x03;    //pb.2 = input 
          
          while (!PINB.2)  
          {
          }; 
          
          h = 0;
          while (PINB.2)
          {
          h++;
          delay_us(10);
          };
          
        
          DDRB=0x07;   //pb.2 = output
              
          if (h<100) // ›«’·Â
          { 
          save_delay ++;
          
          if (save_delay > 3)    
           {
           save_delay = 1;
           }
               
           for (s=1;s<=save_delay ;s++)
           {
             /////////blink hand led///////////
               PORTB.0 = 0; //led
               delay_ms(100);   
               PORTB.0 = 1;
               delay_ms(100);
              //////////////////////////////
           }
           delay_ms(2000);
          
          }   
 }

if (save_delay == 1){pump_delay = 350; }
if (save_delay == 2){pump_delay = 550; }
if (save_delay == 3){pump_delay = 950; }

 };