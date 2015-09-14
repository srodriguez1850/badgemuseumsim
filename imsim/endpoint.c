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
int heldatstart = 0;

void screen_img180();
void screen_img(char *imgaddr);

void main()
{
  // Initialize badge and serial connection
  badge_setup();
  //simpleterm_close();
  
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
  display("Waiting for");
  cursor(4, 5);
  display("a MESSAGE");
  leds_set(0b000000);
  
  leds_set(0b100001);
  ir_start();
  pause(500);
  clear();
  
  while(1)
  {
    memset(&their, 0, sizeof(info));
    print("Enter instant message: ");                 // User prompt
    getStr(text, 15);                           // Text string, max 15 characters
    print("You typed: %s \n", text);
    //if (pad(1) == 1 && pad(4) == 1)
    //{
      strcpy(my_init.email, text);
      clear();
      cursor(3, 1);
      display("Sending...");
      cursor(0, 2);
      display(text);
      led(4, ON); 
      led(1, ON);
      rgb(L, BLUE);
      rgb(R, BLUE);
      ir_send(&my_init);
      rgb(L, OFF);
      rgb(R, OFF);
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
        cursor(2, 4);
        display("Acknowledged!");
        cursor(0, 7);
        display("OSH to Continue.");
        rgb(L, OFF);
        while(pad(6) != 1);
        rgb(R, OFF);
        clear();
      }
      else
      {
        rgb(L, OFF);
        rgb(R, OFF);
      }        
    //}
    //else 
    if(check_inbox() == 1)
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
        ir_send(&my_resp);
        rgb(L, OFF);
        cursor(3, 4);
        display("Should receive");
        cursor(0, 7);
        display("OSH to Continue.");
        rgb(L, OFF);
        while(pad(6) != 1);
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

