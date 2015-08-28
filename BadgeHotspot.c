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
  
  // Connection to host routine
  port = fdserial_open(31, 30, 0, 115200);
  
  while(1)
  {
    char_size(SMALL);
    cursor(4, 1);
    display("HOTSPOT!");
    
    memset(&their, 0, sizeof(info));
    
    int t = CNT;
    int dt = CLKFREQ * 5;
    
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
          dprint(port, "Timed out\n");
          clear_inbox();
          break;
        }
        if (check_inbox() == 1)
        {
          t = CNT;
          message_get(&their);
          if(!strcmp(their.name, "txDone"))
          {
            dprint(port, "End of records.\n\n");
            pause(2000);
            rgb(L, OFF);
            rgb(R, OFF);
            clear();
            break;
          }
          dprint(port, "Name: %s\n", their.name);
          dprint(port, "Email: %s\n", their.email);       
        }
      }        
    }      
  }    
}  