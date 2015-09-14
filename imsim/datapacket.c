#include "simpletools.h"
#include "badgealpha.h"
#include "fdserial.h"

info my = {{" "}, {"INFO"}, 0};
info my_init = {{" "}, {"INIT"}, 0};
info my_resp = {{" "}, {"RESP"}, 0};
info their;
info last = {{" "}, {" "}, 0};

int id_address = 65335;

char handshake[5];
fdserial *port;

int x, y, z;  // accelerometer
int havemessage = 0;

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
  
  
  leds_set(0b100001);
  ir_start();
  pause(500);
  clear();
  
  while(1)
  {
    memset(&their, 0, sizeof(info));
    if (havemessage)
    {
      clear();
      leds_set(0b000000);
      char_size(SMALL);
      cursor(0, 2); 
      display("Bearing Message");
      cursor(5, 3);
      display("to");
      cursor(5, 4);
      display(last.name);
      cursor(0, 5);
      display(last.email);
      cursor(0, 7);
      display("OSH to Continue.");
      while(pad(6) != 1);
    }
    else if (pad(1) == 1 && pad(4) == 1)
    {
      clear();
      cursor(3, 2);
      display("Listening...");
      led(4, ON); 
      led(1, ON);
      rgb(L, BLUE);
      //ir_send(&my_init);
      rgb(L, OFF); 
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
      if (strcmp(their.email, "NULL"))
      {
        memset(&last, 0, sizeof(info));
        last = their;
        ee_save(&their);
        cursor(2, 1);
        display("GOT MESSAGE!");
        cursor(3, 4);
        display("to: %s", their.name);
        cursor(0, 7);
        display("OSH to Continue.");
        rgb(L, OFF);
        while(pad(6) != 1);
        rgb(R, OFF);
        havemessage = 1;
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
      //clear();
      //message_get(&their);
      //if (!strcmp(their.email, "INIT"))
     // {
      //  memset(&last, 0, sizeof(info));
      //  last = their;
      //  ee_save(&their);
      //  cursor(2, 1);
      //  display("INTERACTION!");
      //  rgb(L, BLUE);
     //   ir_send(&my_resp);
      //  rgb(L, OFF);
     //   cursor(3, 4);
     //   display("ID: %s", their.name);
     //   cursor(0, 7);
     //   display("OSH to Continue.");
     //   rgb(L, OFF);
      //  while(pad(6) != 1);
      //  rgb(R, OFF);
     //   clear();
     // }           
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
