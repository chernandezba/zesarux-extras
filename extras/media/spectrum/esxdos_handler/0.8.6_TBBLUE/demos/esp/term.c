//As this has to use the classic library at the moment to get ANSI it can only be a program:

//zcc +zx term.c -create-app -lesxdos -pragma-need=ansiterminal -Cl-v -pragma-define:ansicolumns=64

#include <stdio.h>
//#include <arch/zxn.h>
#include <arch/zxn/esxdos.h>
#include <string.h>
#include <errno.h>

#define NOS_Initialise	 0x80
#define NOS_Shutdown	 0x81
#define NOS_Open	 0xF9
#define NOS_Close	 0xFA
#define NOS_OutputChar	 0xFB
#define NOS_InputChar	 0xFC
#define NOS_GetCurStrPtr 0xFD
#define NOS_SetCurStrPtr 0xFE
#define NOS_GetStrExtent 0xFF
#define NEAT_Deprecated  0x01
#define NEAT_SetCurChan	 0x02
#define NEAT_GetChanVals 0x03
#define NEAT_SetChanVals 0x04
#define NEAT_SetTimeouts 0x05
#define NEAT_AddBank	 0x06
#define NEAT_RemoveBank	 0x07
#define NEAT_GetESPLink	 0x08
#define NEAT_SetBaudRate 0x09
#define NEAT_SetBuffMode 0x0A
#define NEAT_ProcessCMD	 0x0B


static struct esx_drvapi rtc ;// = { 0,0,0 }; //Can't initialise this, if you leave it in it causes error
static struct esx_drvapi net ;// = { 'N'*256 + 0, 0, 0 };

static char CONNECTstring[32] = "TCP,192.168.0.2,10000";

int main(int argc, char **argv)
{
   int x, t;
   int nethandle;

//Pointless doing a static initialiation as union in struct means it is overwritten
   rtc.call.driver = 0;	// This is the main system so RTC
   rtc.call.function = 0;	// No API for rtc
   rtc.de = 0;  // if needed
   rtc.hl = 0; // if needed

   net.call.driver = 'N';	// This is Network should be initialised above
   net.call.function = NOS_Initialise;	// Default is Initialise?
   net.de = 0;  // if needed
   net.hl = 0; // if needed


    /*
        A stupid CSI escape code test
        (normally no one uses CSI?)
*/
   printf("WARNING: ANSI library not working.\n");
   printf("%c2J", 155);
   printf("Z88DK Classic Lib ANSI Terminal\n");

    /*
        Set Graphic Rendition test
*/
   printf("%c[1musing ESPAT.DRV for ZX Next ", 27);
      printf("%c[2mBy Tim Gilberts\n", 27);
   printf("%c[4m(c) 2018 Infinite Imaginations\n", 27);
   printf("%c[24mThanks to AA for the patience!\n", 27);
   printf("%c[7mPress SS and BREAK to exit. ", 27);
   printf("%c[27mH for Help text\n", 27);
   
   printf("Connecting to '%s'.\n", CONNECTstring);
   


   for (t = 1; t < 4; t++) { 
      net.call.driver = 'N';
      net.call.function = NOS_Open ;
      net.hl = CONNECTstring ;
      net.de = strlen( CONNECTstring );

//      printf("%c, %x, %u, %u\n", *((unsigned char *)net),*((unsigned char *)net + 1), *(((int *)net) +1 ), *(((int *)net) + 2));
      printf("HL is at %u of length %u.\n",(char *)CONNECTstring, strlen(CONNECTstring) );

      printf("Try %u to '%s'.\n", t, (char *)net.hl );   

      if(esx_m_drvapi(&net)) {
         printf ("NET Open Driver error %u.\n",errno);
      } else {
 
         nethandle = net.call.function; // As C is a copy of A on exit - added to API

         for (x = 38; x > 30; x--) {
             printf("%c[%umGot NET handle %u %u.\n", 27, x, nethandle, x);
         }

         for (x = 41; x < 47; x++) {
             printf("%c[%umOff to the world of BBS... %u.\n", 27, x, x);
         }
         
         t = 4;
         break;
      }
   }

//        Restore default text attributes

   printf("%c[m", 27);

   printf("%c[%u;%uH*", 27, 10, 30);


   rtc.call.driver = 0;	// This is the main system so RTC
   rtc.call.function = 0;	// No API for rtc       
   if (esx_m_drvapi(&rtc))
      printf ("RTC Driver error %u.\n",errno);

   printf("Time BC= %u DE= %u\n\n",rtc.bc, rtc.de);

   printf("%c[m", 27);

   net.call.function = NOS_Close ;
   net.de = nethandle << 8;
   if (esx_m_drvapi(&net))
      printf ("NET Close Driver error.\n");

   return 0;
}


