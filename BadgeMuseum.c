#include "simpletools.h"
#include "badgealpha.h"
#include "fdserial.h"

info my = {{" "}, {"INFO"}, 0, 0};
info my_init = {{" "}, {"INIT"}, 0, 0};
info my_resp = {{" "}, {"RESP"}, 0, 0};
info their;
info last = {{" "}, {" "}, 0, 0};

int id_address = 65335;

char handshake[5];
fdserial *port;

int x, y, z;  // accelerometer
int heldatstart = 0;

void screen_img180();
void screen_img(char *imgaddr);

void main()
{
  // Initialize badge and serial connection
  badge_setup();
  simpleterm_close();
  
  // Pull ID from EEPROM
  leds_set(0b111111);
  char id[7];
  ee_getStr(id, 7, id_address);
  strcpy(my.name, id);
  strcpy(my_init.name, id);
  strcpy(my_resp.name, id);
  
  pause(200);
  char_size(SMALL);
  cursor(2, 3);
  display("Wipe EEPROM?");
  cursor(4, 5);
  display("Hold OSH");
  leds_set(0b000000);
  if (pad(6) == 1) 
  {
     heldatstart = 1;
  }
  pause(200);    
  leds_set(0b100001);
  pause(200);
  leds_set(0b110011);
  pause(200);
  leds_set(0b111111);
  pause(300);
  clear();
  
  if (heldatstart == 1 && pad(6) == 1)
  {
    ee_wipe();    
  }
  
  leds_set(0b100001);
  ir_start();
  pause(500);
  clear();
  
  while(1)
  {
    memset(&their, 0, sizeof(info));
    tilt_get(&x, &y, &z);
    if (y < -35)
    {
      clear();
      leds_set(0b000000);
      screen_autoUpdate(OFF);
      char_size(SMALL);
      cursor(3, 2); 
      display("ID: %s", my_init.name);
      cursor(0, 5);
      display("Last Interaction");
      cursor(5, 7);
      display(last.name);
      screen_img180();
      screen_autoUpdate(ON);
      while(y < -35)
      {
        tilt_get(&x, &y, &z);
        pause(200);
      }
      clear();
    }
    else if (pad(1) == 1 && pad(4) == 1)
    {
      clear();
      cursor(3, 2);
      display("Sending...");
      led(4, ON); 
      led(1, ON);
      rgb(L, BLUE);
      strcpy(my_init.itime, (char)CNT);
      ir_send(&my_init);
      rgb(L, OFF);
      cursor(6, 4);
      display("DONE");
      cursor(3, 6);
      display("Waiting...");      
      led(4, OFF);
      led(1, OFF);
      
      int t = CNT;
      int dt = CLKFREQ * 2;
      int response = 1;
      
      while (check_inbox() == 0)
      {
        if (CNT - t > dt)
        {
          clear();
          response = 0;
          break;
        }
      }
      if (response == 0) continue;
      
      clear();
      message_get(&their);
      if (!strcmp(their.email, "RESP"))
      {
        memset(&last, 0, sizeof(info));
        last = their;
        ee_save(&their);
        cursor(2, 1);
        display("INTERACTION!");
        cursor(3, 4);
        display("ID: %s", their.name);
        cursor(0, 7);
        display("OSH to Continue.");
        rgb(L, OFF);
        while(pad(6) != 1);
        rgb(R, OFF);
        clear();
      }
      else if (!strcmp(their.email, "DUMP"))
      {
        clear();
        rgb(L, RED);
        rgb(R, RED);
        cursor(1, 3);
        display("EEPROM IR Dump");
        cursor(3, 5);
        display("Keep badge");
        cursor(1, 6);
        display("facing hotspot");
        ir_txContacts();
        clear_inbox();
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
    else if(check_inbox() == 1)
    {
      clear();
      message_get(&their);
      if (!strcmp(their.email, "INIT"))
      {
        memset(&last, 0, sizeof(info));
        last = their;
        ee_save(&their);
        cursor(2, 1);
        display("INTERACTION!");
        rgb(L, BLUE);
        strcpy(my_resp.itime, (char)CNT);
        ir_send(&my_resp);
        rgb(L, OFF);
        cursor(3, 4);
        display("ID: %s", their.name);
        cursor(0, 7);
        display("OSH to Continue.");
        rgb(L, OFF);
        int t = CNT;
        int dt = CLKFREQ * 2;
        while (pad(6) != 1)
        {
          if (CNT - t > dt)
          {
            break;
          }
        }
        rgb(R, OFF);
        clear();
      }           
    }
    else
    {
      char_size(BIG);
      cursor(0, 0); 
      display("%s", my_init.name);
      char_size(SMALL);
      cursor(4, 6);
      display("...is ready.");
      leds_set(0b101101);
      pause(100);
    }      
  }    
}  

/*void screen_img180()
{
  uint32_t screenbuf = screen_getBuffer();
  char *scrbuf = (char *) screenbuf;
  char altbuf[1024];
  memset(altbuf, 0, 1024);
  screen_autoUpdate(OFF);
  int byte, bit, pixel, xp, yp;
  for(int x = 0; x < 128; x++)
  {
    for(int y = 0; y < 64; y++)
    {
      byte = ((y >> 3) << 7) + x;
      bit = y % 8;  
      pixel = 1 & (scrbuf[byte] >> bit);
      
      xp = 127 - x;
      yp = 63 - y;
      
      byte = ((yp >> 3) << 7) + xp;
      bit = yp % 8;  
      altbuf[byte] |= (pixel << bit);
    }
  } 
  memset(scrbuf, 0, 1024);
  memcpy(scrbuf, altbuf, 1024);
  screen_autoUpdate(ON); 
}*/

void screen_img180()
{
  uint32_t screenbuf = screen_getBuffer();
  char *scrbuf = (char *) screenbuf;
  screen_autoUpdate(OFF);
  int byte, bit, pix, xp, yp, bytep, bitp, pixp;
  for(int x = 0; x < 64; x++)
  {
    for(int y = 0; y < 64; y++)
    {
      byte = ((y >> 3) << 7) + x;
      bit = y % 8;  
      pix = 1 & (scrbuf[byte] >> bit);
      
      xp = 127 - x;
      yp = 63 - y;

      bytep = ((yp >> 3) << 7) + xp;
      bitp = yp % 8;  
      pixp = 1 & (scrbuf[bytep] >> bitp);

      scrbuf[bytep] &= ~(1 << bitp);
      scrbuf[bytep] |= (pix << bitp);
      
      scrbuf[byte] &= ~(1 << bit);
      scrbuf[byte] |= (pixp << bit);
    }
  } 
  screen_autoUpdate(ON); 
}

/*
void screen_img(char *imgaddr)
{
  uint32_t screenbuf = screen_getBuffer();
  char *scrbuf = (char *) screenbuf;
  screen_autoUpdate(OFF);
  memcpy(scrbuf, imgaddr, 1024);
  screen_autoUpdate(ON); 
}  

*/