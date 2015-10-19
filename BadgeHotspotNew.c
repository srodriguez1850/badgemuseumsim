#include "simpletools.h"
#include "badgetools.h"
#include "fdserial.h"

typedef struct info_st
{
  char id[7];
  unsigned int cnt;
} info;

info their;

char handshake[5];
fdserial* port;
unsigned int CLKLIMIT;

void upload_contacts(fdserial* port);
void save_contact(info* c);

void main()
{
  badge_setup();
  simpleterm_close();
  contacts_clearAll();
  CLKLIMIT = CLKFREQ * 2;
  
  // Connection to host routine (FORCE CONNECTION TO HOST)
  port = fdserial_open(31, 30, 0, 115200);
  text_size(SMALL);
  cursor(2, 4);
  oledprint("Connecting...");
  /*
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
  */
  clear();
  
  while(1)
  {
    rgb(L, OFF);
    rgb(R, OFF);
        
    text_size(LARGE);
    cursor(0, 0);
    oledprint("HOTSPOT!");
    text_size(SMALL);
    cursor(4, 5);
    oledprint("Start an");
    cursor(1, 6);
    oledprint("interaction to");
    cursor(0, 7);
    oledprint("upload your data");
    
    memset(&their, 0, sizeof(info));
    
    int t = CNT;
    char i_type[5];
    
    // WHY IS THERE A TIMING MISMATCH
    // WHY IS IT BEING CUT OFF
    
    irscan("%s%s", their.id, i_type);
    irclear();
    
    if (strlen(their.id) > 0)
    {
      pause(50);
      clear();
      irprint("%7s\n%5s\n", "htspt1", "DUMP");
      
      text_size(SMALL);
      cursor(2, 2);
      oledprint("Receiving...");
      
      while(1)
      {
        pause(200);
        memset(&their, 0, sizeof(info));
        irscan("%s%u", their.id, their.cnt);
        irclear();
        if (CNT - t > CLKLIMIT)
        {
          clear();
          text_size(SMALL);
          cursor(5, 2);
          oledprint("ERROR!");
          cursor(0, 5);
          oledprint("Please try again");
          dprint(port, "txBegin\n");  
          dprint(port, "Timeout\n");
          contacts_clearAll();
          pause(2000);
          clear();
          break;
        }
        if (strlen(their.id) > 0)
        {
          t = CNT;
          if(!strcmp(their.id, "irDone"))
          {
            text_size(SMALL);
            cursor(0, 5);
            oledprint("Upload complete");
            dprint(port, "txBegin\n");
            //upload_contacts(port);
            contacts_clearAll();
            pause(1000);
            clear();
            break;
          }
          save_contact(&their);
          dprint(port, "ID: %s\n", their.id);
          dprint(port, "Cnt: %u\n", their.cnt);       
        }
      }        
    }      
  }    
}

void upload_contacts(fdserial* port)
{
  int c_count = contacts_count();
  for (int i = 0; i < c_count; i++)
  {
    char id[7];
    unsigned int cnt;
    eescan(i, "%s%u", &id, &cnt);
    dprint(port, "%7s\n%u", id, cnt);
  }    
}

void save_contact(info* c)
{
  eeprint("%7s\n%u\n", c->id, c->cnt);
}