#include "simpletools.h"
#include "badgealpha.h"
#include "fdserial.h"

// Hotspot information to transmit
info my = {{"htspt1"}, {"DUMP"}, 0};
info their;

char handshake[5];
fdserial *port;

void main()
{
  badge_setup();
  simpleterm_close();
  ir_start();
  ee_wipe();
  
  // Connection to host routine (FORCE CONNECTION TO HOST)
  port = fdserial_open(31, 30, 0, 115200);
  char_size(SMALL);
  cursor(2, 4);
  display("Connecting...");
  while(1)
  {
    dprint(port, "Propeller\n");
    pause(1000);  // We need this pause, since the host needs time to respond. 5 x 1 second = 10 second timeout
    if (fdserial_rxCount(port) == 0)
    {
      continue;
    }      
    else if (fdserial_rxCount(port) < 5)
    {
      fdserial_rxFlush(port);
      continue;
    }
    else dscan(port, "%s", handshake);
    // Attempt handshake and listen to response
    if (strcmp(handshake, "H0st") == 0)
    {
      break;
    }      
  }
  clear();
  
  while(1)
  {
    rgb(L, OFF);
    rgb(R, OFF);
        
    char_size(BIG);
    cursor(0, 0);
    display("HOTSPOT!");
    
    memset(&their, 0, sizeof(info));
    
    int t = CNT;
    int dt = CLKFREQ * 2;
    
    if (check_inbox() == 1)
    {
      clear();
      message_get(&their);
      ir_send(&my);
       
      pause(1000); 
      
      while(1)
      {
        if (CNT - t > dt)
        {
          dprint(port, "PropSTART\n");
          ee_uploadContacts(port);
          dprint(port, "Timeout\n");
          clear_inbox();
          break;
        }
        if (check_inbox() == 1)
        {
          t = CNT;
          message_get(&their);
          if(!strcmp(their.name, "txDone"))
          {
            //dprint(port, "End of records.\n\n");
            dprint(port, "PropSTART\n");
            ee_uploadContacts(port);
            clear_inbox();
            pause(1000);
            clear();
            break;
          }
          ee_save(&their);
          //dprint(port, "Name: %s\n", their.name);
          //dprint(port, "Email: %s\n", their.email);       
        }
      }        
    }      
  }    
}  