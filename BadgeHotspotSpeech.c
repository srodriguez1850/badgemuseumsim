#include "simpletools.h"
#include "badgetools.h"
#include "fdserial.h"
#include "text2speech.h"                     // Include text2speech library
#define sound_port (10)

char id[7] = "htspt1";

char handshake[5];
fdserial* port;

talk *spkr;                                  // Talk process ID/data pointer
unsigned int CLKLIMIT;

void upload_contacts(fdserial* port);
void save_contact(char c[]);
void preserve_header(void);

void main()
{
  badge_setup();
  simpleterm_close();
  contacts_clearAll();
  preserve_header();
  CLKLIMIT = CLKFREQ * 2;
  
  // Connection to host routine (FORCE CONNECTION TO HOST)
  port = fdserial_open(31, 30, 0, 115200);
  text_size(SMALL);
  cursor(2, 4);
  oledprint("Connecting...");
  spkr = talk_run(9, 10);                    // Start talk process
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
  
  talk_say(spkr, "heloa");
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
    
    char their_id[7];
    memset(&their_id, 0, 7);
    
    int t = CNT;
    char i_type[5];
    
    irscan("%s%s", their_id, i_type);
    
    if (strlen(their_id) > 0)
    {
      clear();
      eeprint("%s,%u,%s\n", their_id, 0, "INFO");
      irprint("%s\n%s\n", "htspt1", "DUMP");
      
      text_size(SMALL);
      cursor(2, 2);
      oledprint("Receiving...");
      
      while(1)
      {
        char b[128];
        memset(&b, 0, 128);
        irscan("%s", b);
        
        if (CNT - t > CLKLIMIT)
        {
          clear();
          text_size(LARGE);
          cursor(0, 0);
          oledprint(" ERROR");
          text_size(SMALL);
          cursor(0, 6);
          oledprint("Please try again");
          dprint(port, "txBegin\n");  
          dprint(port, "Timeout\n");
          contacts_clearAll();
          preserve_header();
          talk_say(spkr, "oops;/trae,-ugen");
          pause(2000);
          clear();
          break;
        }
        if (strlen(b) > 0)
        {
          t = CNT;
          if(!strcmp(b, "irDone"))
          {
            clear();
            text_size(LARGE);
            cursor(0, 0);
            oledprint("SUCCESS");
            text_size(SMALL);
            cursor(0, 6);
            oledprint("Upload complete");
            talk_say(spkr, "oakay;</aem,dun");
            dprint(port, "txBegin\n");
            upload_contacts(port);
            contacts_clearAll();
            preserve_header();
            pause(1000);
            clear();
            break;
          }
          save_contact(b); 
        }
      }        
    }      
  }    
}

void upload_contacts(fdserial* port)
{
  unsigned int c_count = contacts_count();
  dprint(port, "%u\n", c_count - 1);
  for (int i = 0; i < c_count; i++)
  {
    char b[128];
    eescan(i, "%s", &b);
    dprint(port, "%s\n", b);
  }    
}

void save_contact(char c[])
{
  eeprint("%s\n", c);
}

void preserve_header(void)
{
  eeprint("%s,%u,%s\n", id, 0, "DUMP");
}  