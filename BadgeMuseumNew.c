#include "simpletools.h"
#include "badgetools.h"
#include "fdserial.h"

typedef struct info_st
{
  char id[7];
  char cnt[5];
} info;

info my = {{" "}, 0, 0};
info their;

int id_address = 65335;
// contacts_eraseAll proves to be volatile?

char id[7];
char last[7] = " ";

char handshake[5];
fdserial *port;

int y;  // accelerometer
int heldatstart = 0;
unsigned CNT_sec;

void OSHorWait(int sec);
void cnt_seconds();

void main()
{
  // Initialize badge and serial connection
  badge_setup();
  simpleterm_close();
  
  // Pull ID from EEPROM
  leds(0b111111);
  ee_getStr(id, 7, id_address);
  strcpy(my.id, id);
  
  pause(200);
  text_size(SMALL);
  cursor(2, 3);
  oledprint("Wipe EEPROM?");
  cursor(4, 5);
  oledprint("Hold OSH");
  leds(0b000000);
  if (button(6) == 1) 
  {
     heldatstart = 1;
  }
  pause(200);    
  leds(0b100001);
  pause(200);
  leds(0b110011);
  pause(200);
  leds(0b111111);
  pause(300);
  clear();
  
  if (heldatstart == 1 && button(6) == 1)
  {
    contacts_eraseAll();
  }
  
  leds(0b100001);
  pause(500);
  clear();
  
  while(1)
  { 
    memset(&their, 0, sizeof(info));
    y = accel(AY);
    if (y < -35)
    {
      clear();
      leds(0b000000);
      screen_auto(OFF);
      text_size(SMALL);
      cursor(3, 2); 
      oledprint("ID: %s", my.id);
      cursor(0, 5);
      oledprint("Last Interaction");
      cursor(5, 7);
      oledprint(last);
      rotate180();
      screen_update();
      while(y < -35)
      {
        y = accel(AY);
        pause(200);
      }
      screen_auto(ON);
      clear();
    }
    else if (button(1) == 1 && button(4) == 1)
    {
      clear();
      cursor(3, 2);
      oledprint("Sending...");
      led(4, ON); 
      led(1, ON);
      rgb(L, BLUE);
      irprint("%7s\n%5s\n%5s\n", my.id, "INIT", CNT_sec);
      rgb(L, OFF);
      cursor(6, 4);
      oledprint("DONE");
      cursor(3, 6);
      oledprint("Waiting...");      
      led(4, OFF);
      led(1, OFF);
      
      int t = CNT;
      int dt = CLKFREQ * 2;
      int response = 1;
      char i_type[5];
          
      while(1)
      {
        irscan("%s%s%s", their.id, i_type, their.cnt);  // Receive contact struct
        if (strlen(their.id) > 0) break;
        if (CNT - t > dt)
        {
          clear();
          response = 0;
          break;
        }   
      }        
      if (response == 0) continue;
      
      clear();
      
      if (!strcmp(i_type, "RESP"))
      {
        strcpy(last, their.id);
        cursor(2, 1);
        oledprint("INTERACTION!");
        cursor(3, 4);
        oledprint("ID: %s", their.id);
        cursor(0, 7);
        oledprint("OSH to Continue.");
        rgb(L, OFF);
        OSHorWait(5);
        rgb(R, OFF);
        clear();
      }
      else if (!strcmp(i_type, "DUMP"))
      {
        clear();
        rgb(L, RED);
        rgb(R, RED);
        cursor(1, 3);
        oledprint("EEPROM IR Dump");
        cursor(3, 5);
        oledprint("Keep badge");
        cursor(1, 6);
        oledprint("facing hotspot");
        //ir_txContacts();
        //clear_inbox();
        rgb(L, OFF);
        rgb(R, OFF);
        pause(200);
        clear();
      }
      else
      {
        rgb(L, OFF);
        rgb(R, OFF);
      }        
    }
    else
    {
      char i_type[5];
      irscan("%s%s%s", their.id, i_type, their.cnt);
      
      if (strlen(their.id) > 0)
      {
        strcpy(last, their.id);
      
        if (!strcmp(i_type, "INIT"))
        {
          clear();
          cursor(2, 1);
          oledprint("INTERACTION!");
          irprint("%7s\n%5s\n%5s\n", my.id, "RESP", CNT_sec);
          cursor(3, 4);
          oledprint("ID: %s", their.id);
          cursor(0, 7);
          oledprint("OSH to Continue.");
          rgb(L, OFF);
          OSHorWait(5);
          rgb(R, OFF);
          clear();
        }   
      }
      else
      {
        text_size(LARGE);
        cursor(0, 0); 
        oledprint("%s", my.id);
        text_size(SMALL);
        cursor(4, 6);
        oledprint("...is ready.");
        leds(0b101101);
        pause(100);
      }            
    }      
  }    
}  

void OSHorWait(int sec)
{
  int t = CNT;
  int dt = CLKFREQ * sec;
  while (button(6) != 1)
  {
   if (CNT - t > dt)
   {
     break;
   }
 } 
}

void cnt_seconds(void)
{
  CNT_sec = 0;
  int t = CNT;
  while (1)
  {
    if (CNT - t > CLKFREQ)
    {
      t = CNT;
      CNT_sec++;
    }      
  }      
}