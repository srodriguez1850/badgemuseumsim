 GNU assembler version 2.21 (propeller-elf)
	 using BFD version (propellergcc_v1_0_0_2408) 2.21.
 options passed	: -lmm -cmm -ahdlnsg=cmm/BadgeMuseum.asm 
 input file    	: C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s
 output file   	: cmm/BadgeMuseum.o
 target        	: propeller-parallax-elf
 time stamp    	: 

   1              		.text
   2              	.Ltext0
   3              		.global	_screen_img180
   4              	_screen_img180
   5              	.LFB2
   6              		.file 1 "BadgeMuseum.c"
   1:BadgeMuseum.c **** #include "simpletools.h"
   2:BadgeMuseum.c **** #include "badgealpha.h"
   3:BadgeMuseum.c **** #include "fdserial.h"
   4:BadgeMuseum.c **** 
   5:BadgeMuseum.c **** info my = {{" "}, {"INFO"}, 0, 0};
   6:BadgeMuseum.c **** info my_init = {{" "}, {"INIT"}, 0, 0};
   7:BadgeMuseum.c **** info my_resp = {{" "}, {"RESP"}, 0, 0};
   8:BadgeMuseum.c **** info their;
   9:BadgeMuseum.c **** info last = {{" "}, {" "}, 0, 0};
  10:BadgeMuseum.c **** 
  11:BadgeMuseum.c **** int id_address = 65335;
  12:BadgeMuseum.c **** 
  13:BadgeMuseum.c **** char handshake[5];
  14:BadgeMuseum.c **** fdserial *port;
  15:BadgeMuseum.c **** 
  16:BadgeMuseum.c **** int x, y, z;  // accelerometer
  17:BadgeMuseum.c **** int heldatstart = 0;
  18:BadgeMuseum.c **** 
  19:BadgeMuseum.c **** void screen_img180();
  20:BadgeMuseum.c **** void screen_img(char *imgaddr);
  21:BadgeMuseum.c **** 
  22:BadgeMuseum.c **** void main()
  23:BadgeMuseum.c **** {
  24:BadgeMuseum.c ****   // Initialize badge and serial connection
  25:BadgeMuseum.c ****   badge_setup();
  26:BadgeMuseum.c ****   simpleterm_close();
  27:BadgeMuseum.c ****   
  28:BadgeMuseum.c ****   // Pull ID from EEPROM
  29:BadgeMuseum.c ****   leds_set(0b111111);
  30:BadgeMuseum.c ****   char id[7];
  31:BadgeMuseum.c ****   ee_getStr(id, 7, id_address);
  32:BadgeMuseum.c ****   strcpy(my.name, id);
  33:BadgeMuseum.c ****   strcpy(my_init.name, id);
  34:BadgeMuseum.c ****   strcpy(my_resp.name, id);
  35:BadgeMuseum.c ****   
  36:BadgeMuseum.c ****   pause(200);
  37:BadgeMuseum.c ****   char_size(SMALL);
  38:BadgeMuseum.c ****   cursor(2, 3);
  39:BadgeMuseum.c ****   display("Wipe EEPROM?");
  40:BadgeMuseum.c ****   cursor(4, 5);
  41:BadgeMuseum.c ****   display("Hold OSH");
  42:BadgeMuseum.c ****   leds_set(0b000000);
  43:BadgeMuseum.c ****   if (pad(6) == 1) 
  44:BadgeMuseum.c ****   {
  45:BadgeMuseum.c ****      heldatstart = 1;
  46:BadgeMuseum.c ****   }
  47:BadgeMuseum.c ****   pause(200);    
  48:BadgeMuseum.c ****   leds_set(0b100001);
  49:BadgeMuseum.c ****   pause(200);
  50:BadgeMuseum.c ****   leds_set(0b110011);
  51:BadgeMuseum.c ****   pause(200);
  52:BadgeMuseum.c ****   leds_set(0b111111);
  53:BadgeMuseum.c ****   pause(300);
  54:BadgeMuseum.c ****   clear();
  55:BadgeMuseum.c ****   
  56:BadgeMuseum.c ****   if (heldatstart == 1 && pad(6) == 1)
  57:BadgeMuseum.c ****   {
  58:BadgeMuseum.c ****     ee_wipe();    
  59:BadgeMuseum.c ****   }
  60:BadgeMuseum.c ****   
  61:BadgeMuseum.c ****   leds_set(0b100001);
  62:BadgeMuseum.c ****   ir_start();
  63:BadgeMuseum.c ****   pause(500);
  64:BadgeMuseum.c ****   clear();
  65:BadgeMuseum.c ****   
  66:BadgeMuseum.c ****   while(1)
  67:BadgeMuseum.c ****   {
  68:BadgeMuseum.c ****     memset(&their, 0, sizeof(info));
  69:BadgeMuseum.c ****     tilt_get(&x, &y, &z);
  70:BadgeMuseum.c ****     if (y < -35)
  71:BadgeMuseum.c ****     {
  72:BadgeMuseum.c ****       clear();
  73:BadgeMuseum.c ****       leds_set(0b000000);
  74:BadgeMuseum.c ****       screen_autoUpdate(OFF);
  75:BadgeMuseum.c ****       char_size(SMALL);
  76:BadgeMuseum.c ****       cursor(3, 2); 
  77:BadgeMuseum.c ****       display("ID: %s", my_init.name);
  78:BadgeMuseum.c ****       cursor(0, 5);
  79:BadgeMuseum.c ****       display("Last Interaction");
  80:BadgeMuseum.c ****       cursor(5, 7);
  81:BadgeMuseum.c ****       display(last.name);
  82:BadgeMuseum.c ****       screen_img180();
  83:BadgeMuseum.c ****       screen_autoUpdate(ON);
  84:BadgeMuseum.c ****       while(y < -35)
  85:BadgeMuseum.c ****       {
  86:BadgeMuseum.c ****         tilt_get(&x, &y, &z);
  87:BadgeMuseum.c ****         pause(200);
  88:BadgeMuseum.c ****       }
  89:BadgeMuseum.c ****       clear();
  90:BadgeMuseum.c ****     }
  91:BadgeMuseum.c ****     else if (pad(1) == 1 && pad(4) == 1)
  92:BadgeMuseum.c ****     {
  93:BadgeMuseum.c ****       clear();
  94:BadgeMuseum.c ****       cursor(3, 2);
  95:BadgeMuseum.c ****       display("Sending...");
  96:BadgeMuseum.c ****       led(4, ON); 
  97:BadgeMuseum.c ****       led(1, ON);
  98:BadgeMuseum.c ****       rgb(L, BLUE);
  99:BadgeMuseum.c ****       strcpy(my_init.itime, (char)CNT);
 100:BadgeMuseum.c ****       ir_send(&my_init);
 101:BadgeMuseum.c ****       rgb(L, OFF);
 102:BadgeMuseum.c ****       cursor(6, 4);
 103:BadgeMuseum.c ****       display("DONE");
 104:BadgeMuseum.c ****       cursor(3, 6);
 105:BadgeMuseum.c ****       display("Waiting...");      
 106:BadgeMuseum.c ****       led(4, OFF);
 107:BadgeMuseum.c ****       led(1, OFF);
 108:BadgeMuseum.c ****       
 109:BadgeMuseum.c ****       int t = CNT;
 110:BadgeMuseum.c ****       int dt = CLKFREQ * 2;
 111:BadgeMuseum.c ****       int response = 1;
 112:BadgeMuseum.c ****       
 113:BadgeMuseum.c ****       while (check_inbox() == 0)
 114:BadgeMuseum.c ****       {
 115:BadgeMuseum.c ****         if (CNT - t > dt)
 116:BadgeMuseum.c ****         {
 117:BadgeMuseum.c ****           clear();
 118:BadgeMuseum.c ****           response = 0;
 119:BadgeMuseum.c ****           break;
 120:BadgeMuseum.c ****         }
 121:BadgeMuseum.c ****       }
 122:BadgeMuseum.c ****       if (response == 0) continue;
 123:BadgeMuseum.c ****       
 124:BadgeMuseum.c ****       clear();
 125:BadgeMuseum.c ****       message_get(&their);
 126:BadgeMuseum.c ****       if (!strcmp(their.email, "RESP"))
 127:BadgeMuseum.c ****       {
 128:BadgeMuseum.c ****         memset(&last, 0, sizeof(info));
 129:BadgeMuseum.c ****         last = their;
 130:BadgeMuseum.c ****         ee_save(&their);
 131:BadgeMuseum.c ****         cursor(2, 1);
 132:BadgeMuseum.c ****         display("INTERACTION!");
 133:BadgeMuseum.c ****         cursor(3, 4);
 134:BadgeMuseum.c ****         display("ID: %s", their.name);
 135:BadgeMuseum.c ****         cursor(0, 7);
 136:BadgeMuseum.c ****         display("OSH to Continue.");
 137:BadgeMuseum.c ****         rgb(L, OFF);
 138:BadgeMuseum.c ****         while(pad(6) != 1);
 139:BadgeMuseum.c ****         rgb(R, OFF);
 140:BadgeMuseum.c ****         clear();
 141:BadgeMuseum.c ****       }
 142:BadgeMuseum.c ****       else if (!strcmp(their.email, "DUMP"))
 143:BadgeMuseum.c ****       {
 144:BadgeMuseum.c ****         clear();
 145:BadgeMuseum.c ****         rgb(L, RED);
 146:BadgeMuseum.c ****         rgb(R, RED);
 147:BadgeMuseum.c ****         cursor(1, 3);
 148:BadgeMuseum.c ****         display("EEPROM IR Dump");
 149:BadgeMuseum.c ****         cursor(3, 5);
 150:BadgeMuseum.c ****         display("Keep badge");
 151:BadgeMuseum.c ****         cursor(1, 6);
 152:BadgeMuseum.c ****         display("facing hotspot");
 153:BadgeMuseum.c ****         ir_txContacts();
 154:BadgeMuseum.c ****         clear_inbox();
 155:BadgeMuseum.c ****         rgb(L, OFF);
 156:BadgeMuseum.c ****         rgb(R, OFF);
 157:BadgeMuseum.c ****         pause(200);
 158:BadgeMuseum.c ****         clear();
 159:BadgeMuseum.c ****       }
 160:BadgeMuseum.c ****       else
 161:BadgeMuseum.c ****       {
 162:BadgeMuseum.c ****         rgb(L, OFF);
 163:BadgeMuseum.c ****         rgb(R, OFF);
 164:BadgeMuseum.c ****       }        
 165:BadgeMuseum.c ****     }
 166:BadgeMuseum.c ****     else if(check_inbox() == 1)
 167:BadgeMuseum.c ****     {
 168:BadgeMuseum.c ****       clear();
 169:BadgeMuseum.c ****       message_get(&their);
 170:BadgeMuseum.c ****       if (!strcmp(their.email, "INIT"))
 171:BadgeMuseum.c ****       {
 172:BadgeMuseum.c ****         memset(&last, 0, sizeof(info));
 173:BadgeMuseum.c ****         last = their;
 174:BadgeMuseum.c ****         ee_save(&their);
 175:BadgeMuseum.c ****         cursor(2, 1);
 176:BadgeMuseum.c ****         display("INTERACTION!");
 177:BadgeMuseum.c ****         rgb(L, BLUE);
 178:BadgeMuseum.c ****         strcpy(my_resp.itime, (char)CNT);
 179:BadgeMuseum.c ****         ir_send(&my_resp);
 180:BadgeMuseum.c ****         rgb(L, OFF);
 181:BadgeMuseum.c ****         cursor(3, 4);
 182:BadgeMuseum.c ****         display("ID: %s", their.name);
 183:BadgeMuseum.c ****         cursor(0, 7);
 184:BadgeMuseum.c ****         display("OSH to Continue.");
 185:BadgeMuseum.c ****         rgb(L, OFF);
 186:BadgeMuseum.c ****         int t = CNT;
 187:BadgeMuseum.c ****         int dt = CLKFREQ * 2;
 188:BadgeMuseum.c ****         while (pad(6) != 1)
 189:BadgeMuseum.c ****         {
 190:BadgeMuseum.c ****           if (CNT - t > dt)
 191:BadgeMuseum.c ****           {
 192:BadgeMuseum.c ****             break;
 193:BadgeMuseum.c ****           }
 194:BadgeMuseum.c ****         }
 195:BadgeMuseum.c ****         rgb(R, OFF);
 196:BadgeMuseum.c ****         clear();
 197:BadgeMuseum.c ****       }           
 198:BadgeMuseum.c ****     }
 199:BadgeMuseum.c ****     else
 200:BadgeMuseum.c ****     {
 201:BadgeMuseum.c ****       char_size(BIG);
 202:BadgeMuseum.c ****       cursor(0, 0); 
 203:BadgeMuseum.c ****       display("%s", my_init.name);
 204:BadgeMuseum.c ****       char_size(SMALL);
 205:BadgeMuseum.c ****       cursor(4, 6);
 206:BadgeMuseum.c ****       display("...is ready.");
 207:BadgeMuseum.c ****       leds_set(0b101101);
 208:BadgeMuseum.c ****       pause(100);
 209:BadgeMuseum.c ****     }      
 210:BadgeMuseum.c ****   }    
 211:BadgeMuseum.c **** }  
 212:BadgeMuseum.c **** 
 213:BadgeMuseum.c **** /*void screen_img180()
 214:BadgeMuseum.c **** {
 215:BadgeMuseum.c ****   uint32_t screenbuf = screen_getBuffer();
 216:BadgeMuseum.c ****   char *scrbuf = (char *) screenbuf;
 217:BadgeMuseum.c ****   char altbuf[1024];
 218:BadgeMuseum.c ****   memset(altbuf, 0, 1024);
 219:BadgeMuseum.c ****   screen_autoUpdate(OFF);
 220:BadgeMuseum.c ****   int byte, bit, pixel, xp, yp;
 221:BadgeMuseum.c ****   for(int x = 0; x < 128; x++)
 222:BadgeMuseum.c ****   {
 223:BadgeMuseum.c ****     for(int y = 0; y < 64; y++)
 224:BadgeMuseum.c ****     {
 225:BadgeMuseum.c ****       byte = ((y >> 3) << 7) + x;
 226:BadgeMuseum.c ****       bit = y % 8;  
 227:BadgeMuseum.c ****       pixel = 1 & (scrbuf[byte] >> bit);
 228:BadgeMuseum.c ****       
 229:BadgeMuseum.c ****       xp = 127 - x;
 230:BadgeMuseum.c ****       yp = 63 - y;
 231:BadgeMuseum.c ****       
 232:BadgeMuseum.c ****       byte = ((yp >> 3) << 7) + xp;
 233:BadgeMuseum.c ****       bit = yp % 8;  
 234:BadgeMuseum.c ****       altbuf[byte] |= (pixel << bit);
 235:BadgeMuseum.c ****     }
 236:BadgeMuseum.c ****   } 
 237:BadgeMuseum.c ****   memset(scrbuf, 0, 1024);
 238:BadgeMuseum.c ****   memcpy(scrbuf, altbuf, 1024);
 239:BadgeMuseum.c ****   screen_autoUpdate(ON); 
 240:BadgeMuseum.c **** }*/
 241:BadgeMuseum.c **** 
 242:BadgeMuseum.c **** void screen_img180()
 243:BadgeMuseum.c **** {
   7              		.loc 1 243 0
   8 0000 036A     		lpushm	#(6<<4)+10
   9              	.LCFI0
 244:BadgeMuseum.c ****   uint32_t screenbuf = screen_getBuffer();
  10              		.loc 1 244 0
  11 0002 060000   		lcall	#_screen_getBuffer
  12 0005 0AD0     		mov	r13, r0
  13              	.LVL0
 245:BadgeMuseum.c ****   char *scrbuf = (char *) screenbuf;
 246:BadgeMuseum.c ****   screen_autoUpdate(OFF);
  14              		.loc 1 246 0
  15 0007 B0       		mov	r0, #0
  16              	.LVL1
  17              	.LBB2
  18              	.LBB3
 242:BadgeMuseum.c **** void screen_img180()
  19              		.loc 1 242 0
  20 0008 AB3F     		mov	r11, #63
  21 000a AC7F     		mov	r12, #127
  22              	.LBE3
  23              	.LBE2
  24              		.loc 1 246 0
  25 000c 060000   		lcall	#_screen_autoUpdate
  26              	.LVL2
 247:BadgeMuseum.c ****   int byte, bit, pix, xp, yp, bytep, bitp, pixp;
 248:BadgeMuseum.c ****   for(int x = 0; x < 64; x++)
  27              		.loc 1 248 0
  28 000f B3       		mov	r3, #0
  29              	.LBB7
  30              	.LBB4
 249:BadgeMuseum.c ****   {
 250:BadgeMuseum.c ****     for(int y = 0; y < 64; y++)
 251:BadgeMuseum.c ****     {
 252:BadgeMuseum.c ****       byte = ((y >> 3) << 7) + x;
 253:BadgeMuseum.c ****       bit = y % 8;  
 254:BadgeMuseum.c ****       pix = 1 & (scrbuf[byte] >> bit);
 255:BadgeMuseum.c ****       
 256:BadgeMuseum.c ****       xp = 127 - x;
 257:BadgeMuseum.c ****       yp = 63 - y;
 258:BadgeMuseum.c **** 
 259:BadgeMuseum.c ****       bytep = ((yp >> 3) << 7) + xp;
 260:BadgeMuseum.c ****       bitp = yp % 8;  
 261:BadgeMuseum.c ****       pixp = 1 & (scrbuf[bytep] >> bitp);
 262:BadgeMuseum.c **** 
 263:BadgeMuseum.c ****       scrbuf[bytep] &= ~(1 << bitp);
  31              		.loc 1 263 0
  32 0010 AE01     		mov	r14, #1
  33 0012 4F0000   		brw	#.L2
  34              	.LVL3
  35              	.L3
 242:BadgeMuseum.c **** void screen_img180()
  36              		.loc 1 242 0 discriminator 2
  37 0015 D66B41   		xmov	r6,r11 sub r6,r4
 260:BadgeMuseum.c ****       bitp = yp % 8;  
  38              		.loc 1 260 0 discriminator 2
  39 0018 E6163B   		xmov	r1,r6 sar r6,#3
 252:BadgeMuseum.c ****       byte = ((y >> 3) << 7) + x;
  40              		.loc 1 252 0 discriminator 2
  41 001b E67479   		xmov	r7,r4 shl r6,#7
  42 001e 273B     		sar	r7, #3
 259:BadgeMuseum.c ****       bytep = ((yp >> 3) << 7) + xp;
  43              		.loc 1 259 0 discriminator 2
  44 0020 16A0     		add	r6, r10
 261:BadgeMuseum.c ****       pixp = 1 & (scrbuf[bytep] >> bitp);
  45              		.loc 1 261 0 discriminator 2
  46 0022 16D0     		add	r6, r13
 252:BadgeMuseum.c ****       byte = ((y >> 3) << 7) + x;
  47              		.loc 1 252 0 discriminator 2
  48 0024 2779     		shl	r7, #7
 260:BadgeMuseum.c ****       bitp = yp % 8;  
  49              		.loc 1 260 0 discriminator 2
  50 0026 2174     		and	r1, #7
 252:BadgeMuseum.c ****       byte = ((y >> 3) << 7) + x;
  51              		.loc 1 252 0 discriminator 2
  52 0028 1730     		add	r7, r3
  53              		.loc 1 263 0 discriminator 2
  54 002a D75ED0   		xmov	r5,r14 add r7,r13
 253:BadgeMuseum.c ****       bit = y % 8;  
  55              		.loc 1 253 0 discriminator 2
  56 002d D52419   		xmov	r2,r4 shl r5,r1
  57 0030 2274     		and	r2, #7
  58              	.LVL4
 250:BadgeMuseum.c ****     for(int y = 0; y < 64; y++)
  59              		.loc 1 250 0 discriminator 2
  60 0032 2410     		add	r4, #1
  61              	.LVL5
  62 0034 344020   		cmps	r4, #64 wz,wc
 261:BadgeMuseum.c ****       pixp = 1 & (scrbuf[bytep] >> bitp);
  63              		.loc 1 261 0 discriminator 2
  64 0037 106C     		rdbyte	r0, r6
  65              	.LVL6
  66              		.loc 1 263 0 discriminator 2
  67 0039 0AF0     		mov	lr, r0
  68 003b 1F55     		andn	lr, r5
 254:BadgeMuseum.c ****       pix = 1 & (scrbuf[byte] >> bit);
  69              		.loc 1 254 0 discriminator 2
  70 003d 157C     		rdbyte	r5, r7
  71 003f 152B     		sar	r5, r2
  72 0041 2514     		and	r5, #1
 264:BadgeMuseum.c ****       scrbuf[bytep] |= (pix << bitp);
  73              		.loc 1 264 0 discriminator 2
  74 0043 1519     		shl	r5, r1
  75 0045 1F57     		or	lr, r5
 265:BadgeMuseum.c ****       
 266:BadgeMuseum.c ****       scrbuf[byte] &= ~(1 << bit);
  76              		.loc 1 266 0 discriminator 2
  77 0047 D55E29   		xmov	r5,r14 shl r5,r2
 264:BadgeMuseum.c ****       scrbuf[bytep] |= (pix << bitp);
  78              		.loc 1 264 0 discriminator 2
  79 004a 1F6E     		wrbyte	lr, r6
 261:BadgeMuseum.c ****       pixp = 1 & (scrbuf[bytep] >> bitp);
  80              		.loc 1 261 0 discriminator 2
  81 004c D6601B   		xmov	r6,r0 sar r6,r1
  82 004f 2614     		and	r6, #1
 267:BadgeMuseum.c ****       scrbuf[byte] |= (pixp << bit);
  83              		.loc 1 267 0 discriminator 2
  84 0051 1629     		shl	r6, r2
 266:BadgeMuseum.c ****       scrbuf[byte] &= ~(1 << bit);
  85              		.loc 1 266 0 discriminator 2
  86 0053 0A25     		mov	r2, r5
  87              	.LVL7
  88 0055 157C     		rdbyte	r5, r7
  89 0057 1525     		andn	r5, r2
  90              		.loc 1 267 0 discriminator 2
  91 0059 1657     		or	r6, r5
  92 005b 167E     		wrbyte	r6, r7
 250:BadgeMuseum.c ****     for(int y = 0; y < 64; y++)
  93              		.loc 1 250 0 discriminator 2
  94 005d 450000   		IF_NE	brw	#.L3
  95              	.LBE4
 248:BadgeMuseum.c ****   for(int x = 0; x < 64; x++)
  96              		.loc 1 248 0
  97 0060 2310     		add	r3, #1
  98              	.LVL8
  99 0062 334020   		cmps	r3, #64 wz,wc
 100 0065 7A08     		IF_E 	brs	#.L4
 101              	.LVL9
 102              	.L2
 103              	.LBB5
 242:BadgeMuseum.c **** void screen_img180()
 104              		.loc 1 242 0 discriminator 1
 105 0067 0AAC     		mov	r10, r12
 106              	.LBE5
 107              	.LBE7
 243:BadgeMuseum.c **** {
 108              		.loc 1 243 0 discriminator 1
 109 0069 B4       		mov	r4, #0
 110              	.LBB8
 111              	.LBB6
 242:BadgeMuseum.c **** void screen_img180()
 112              		.loc 1 242 0 discriminator 1
 113 006a 1A31     		sub	r10, r3
 114 006c 4F0000   		brw	#.L3
 115              	.LVL10
 116              	.L4
 117              	.LBE6
 118              	.LBE8
 268:BadgeMuseum.c ****     }
 269:BadgeMuseum.c ****   } 
 270:BadgeMuseum.c ****   screen_autoUpdate(ON); 
 119              		.loc 1 270 0
 120 006f A001     		mov	r0, #1
 121              	.LVL11
 122 0071 060000   		lcall	#_screen_autoUpdate
 123              	.LVL12
 271:BadgeMuseum.c **** }
 124              		.loc 1 271 0
 125 0074 056F     		lpopret	#(6<<4)+15
 126              	.LFE2
 127              		.data
 128              		.balign	4
 129              	.LC0
 130 0000 57697065 		.ascii "Wipe EEPROM?\0"
 130      20454550 
 130      524F4D3F 
 130      00
 131 000d 000000   		.balign	4
 132              	.LC1
 133 0010 486F6C64 		.ascii "Hold OSH\0"
 133      204F5348 
 133      00
 134 0019 000000   		.balign	4
 135              	.LC2
 136 001c 49443A20 		.ascii "ID: %s\0"
 136      257300
 137 0023 00       		.balign	4
 138              	.LC3
 139 0024 4C617374 		.ascii "Last Interaction\0"
 139      20496E74 
 139      65726163 
 139      74696F6E 
 139      00
 140 0035 000000   		.balign	4
 141              	.LC4
 142 0038 53656E64 		.ascii "Sending...\0"
 142      696E672E 
 142      2E2E00
 143 0043 00       		.balign	4
 144              	.LC5
 145 0044 444F4E45 		.ascii "DONE\0"
 145      00
 146 0049 000000   		.balign	4
 147              	.LC6
 148 004c 57616974 		.ascii "Waiting...\0"
 148      696E672E 
 148      2E2E00
 149 0057 00       		.balign	4
 150              	.LC7
 151 0058 494E5445 		.ascii "INTERACTION!\0"
 151      52414354 
 151      494F4E21 
 151      00
 152 0065 000000   		.balign	4
 153              	.LC8
 154 0068 4F534820 		.ascii "OSH to Continue.\0"
 154      746F2043 
 154      6F6E7469 
 154      6E75652E 
 154      00
 155 0079 000000   		.balign	4
 156              	.LC9
 157 007c 44554D50 		.ascii "DUMP\0"
 157      00
 158 0081 000000   		.balign	4
 159              	.LC10
 160 0084 45455052 		.ascii "EEPROM IR Dump\0"
 160      4F4D2049 
 160      52204475 
 160      6D7000
 161 0093 00       		.balign	4
 162              	.LC11
 163 0094 4B656570 		.ascii "Keep badge\0"
 163      20626164 
 163      676500
 164 009f 00       		.balign	4
 165              	.LC12
 166 00a0 66616369 		.ascii "facing hotspot\0"
 166      6E672068 
 166      6F747370 
 166      6F7400
 167 00af 00       		.balign	4
 168              	.LC13
 169 00b0 494E4954 		.ascii "INIT\0"
 169      00
 170 00b5 000000   		.balign	4
 171              	.LC14
 172 00b8 257300   		.ascii "%s\0"
 173 00bb 00       		.balign	4
 174              	.LC15
 175 00bc 2E2E2E69 		.ascii "...is ready.\0"
 175      73207265 
 175      6164792E 
 175      00
 176 00c9 000000   		.balign	4
 177              	.LC16
 178 00cc 52455350 		.ascii "RESP\0"
 178      00
 179              		.text
 180              		.global	_main
 181              	_main
 182              	.LFB1
  23:BadgeMuseum.c **** {
 183              		.loc 1 23 0
 184 0076 035B     		lpushm	#(5<<4)+11
 185              	.LCFI1
 186 0078 0CF0     		sub	sp, #16
 187              	.LCFI2
  25:BadgeMuseum.c ****   badge_setup();
 188              		.loc 1 25 0
 189 007a 060000   		lcall	#_badge_setup
  26:BadgeMuseum.c ****   simpleterm_close();
 190              		.loc 1 26 0
 191 007d 060000   		lcall	#_simpleterm_close
  29:BadgeMuseum.c ****   leds_set(0b111111);
 192              		.loc 1 29 0
 193 0080 A03F     		mov	r0, #63
 194 0082 060000   		lcall	#_leds_set
  31:BadgeMuseum.c ****   ee_getStr(id, 7, id_address);
 195              		.loc 1 31 0
 196 0085 670000   		mviw	r7,#_id_address
 197 0088 A107     		mov	r1, #7
 198 008a C008     		leasp r0,#8
 199 008c 127D     		rdlong	r2, r7
 200 008e 060000   		lcall	#_ee_getStr
  32:BadgeMuseum.c ****   strcpy(my.name, id);
 201              		.loc 1 32 0
 202 0091 C108     		leasp r1,#8
 203 0093 600000   		mviw	r0,#_my
 204 0096 060000   		lcall	#_strcpy
  33:BadgeMuseum.c ****   strcpy(my_init.name, id);
 205              		.loc 1 33 0
 206 0099 C108     		leasp r1,#8
 207 009b 600000   		mviw	r0,#_my_init
 208 009e 060000   		lcall	#_strcpy
  34:BadgeMuseum.c ****   strcpy(my_resp.name, id);
 209              		.loc 1 34 0
 210 00a1 C108     		leasp r1,#8
 211 00a3 600000   		mviw	r0,#_my_resp
 212 00a6 060000   		lcall	#_strcpy
  36:BadgeMuseum.c ****   pause(200);
 213              		.loc 1 36 0
 214 00a9 A0C8     		mov	r0, #200
 215 00ab 060000   		lcall	#_pause
  37:BadgeMuseum.c ****   char_size(SMALL);
 216              		.loc 1 37 0
 217 00ae B0       		mov	r0, #0
 218 00af 060000   		lcall	#_char_size
  38:BadgeMuseum.c ****   cursor(2, 3);
 219              		.loc 1 38 0
 220 00b2 A103     		mov	r1, #3
 221 00b4 A002     		mov	r0, #2
 222 00b6 060000   		lcall	#_cursor
  39:BadgeMuseum.c ****   display("Wipe EEPROM?");
 223              		.loc 1 39 0
 224 00b9 660000   		mviw	r6,#.LC0
 225 00bc F0100C08 		wrlong	r6, sp
 226 00c0 060000   		lcall	#_display
  40:BadgeMuseum.c ****   cursor(4, 5);
 227              		.loc 1 40 0
 228 00c3 A105     		mov	r1, #5
 229 00c5 A004     		mov	r0, #4
 230 00c7 060000   		lcall	#_cursor
  41:BadgeMuseum.c ****   display("Hold OSH");
 231              		.loc 1 41 0
 232 00ca 670000   		mviw	r7,#.LC1
 233 00cd F0100E08 		wrlong	r7, sp
 234 00d1 060000   		lcall	#_display
  42:BadgeMuseum.c ****   leds_set(0b000000);
 235              		.loc 1 42 0
 236 00d4 B0       		mov	r0, #0
 237 00d5 060000   		lcall	#_leds_set
  43:BadgeMuseum.c ****   if (pad(6) == 1) 
 238              		.loc 1 43 0
 239 00d8 A006     		mov	r0, #6
 240 00da 060000   		lcall	#_pad
 241 00dd 2012     		cmps	r0, #1 wz,wc
 242 00df 7507     		IF_NE	brs	#.L8
  45:BadgeMuseum.c ****      heldatstart = 1;
 243              		.loc 1 45 0
 244 00e1 670000   		mviw	r7,#_heldatstart
 245 00e4 A601     		mov	r6, #1
 246 00e6 167F     		wrlong	r6, r7
 247              	.L8
  47:BadgeMuseum.c ****   pause(200);    
 248              		.loc 1 47 0
 249 00e8 A0C8     		mov	r0, #200
 250 00ea 060000   		lcall	#_pause
  48:BadgeMuseum.c ****   leds_set(0b100001);
 251              		.loc 1 48 0
 252 00ed A021     		mov	r0, #33
 253 00ef 060000   		lcall	#_leds_set
  49:BadgeMuseum.c ****   pause(200);
 254              		.loc 1 49 0
 255 00f2 A0C8     		mov	r0, #200
 256 00f4 060000   		lcall	#_pause
  50:BadgeMuseum.c ****   leds_set(0b110011);
 257              		.loc 1 50 0
 258 00f7 A033     		mov	r0, #51
 259 00f9 060000   		lcall	#_leds_set
  51:BadgeMuseum.c ****   pause(200);
 260              		.loc 1 51 0
 261 00fc A0C8     		mov	r0, #200
 262 00fe 060000   		lcall	#_pause
  52:BadgeMuseum.c ****   leds_set(0b111111);
 263              		.loc 1 52 0
 264 0101 A03F     		mov	r0, #63
 265 0103 060000   		lcall	#_leds_set
  53:BadgeMuseum.c ****   pause(300);
 266              		.loc 1 53 0
 267 0106 602C01   		mov	r0, #300
 268 0109 060000   		lcall	#_pause
  54:BadgeMuseum.c ****   clear();
 269              		.loc 1 54 0
 270 010c 060000   		lcall	#_screen_clear
  56:BadgeMuseum.c ****   if (heldatstart == 1 && pad(6) == 1)
 271              		.loc 1 56 0
 272 010f 670000   		mviw	r7,#_heldatstart
 273 0112 177D     		rdlong	r7, r7
 274 0114 2712     		cmps	r7, #1 wz,wc
 275 0116 750C     		IF_NE	brs	#.L9
  56:BadgeMuseum.c ****   if (heldatstart == 1 && pad(6) == 1)
 276              		.loc 1 56 0 is_stmt 0 discriminator 1
 277 0118 A006     		mov	r0, #6
 278 011a 060000   		lcall	#_pad
 279 011d 2012     		cmps	r0, #1 wz,wc
 280 011f 7503     		IF_NE	brs	#.L9
  58:BadgeMuseum.c ****     ee_wipe();    
 281              		.loc 1 58 0 is_stmt 1
 282 0121 060000   		lcall	#_ee_wipe
 283              	.L9
  61:BadgeMuseum.c ****   leds_set(0b100001);
 284              		.loc 1 61 0
 285 0124 A021     		mov	r0, #33
 286              	.LBB9
 178:BadgeMuseum.c ****         strcpy(my_resp.itime, (char)CNT);
 287              		.loc 1 178 0
 288 0126 6C0000   		mviw	r12,#_my_resp+14
 289              	.LBE9
  61:BadgeMuseum.c ****   leds_set(0b100001);
 290              		.loc 1 61 0
 291 0129 060000   		lcall	#_leds_set
  62:BadgeMuseum.c ****   ir_start();
 292              		.loc 1 62 0
 293 012c 060000   		lcall	#_ir_start
  63:BadgeMuseum.c ****   pause(500);
 294              		.loc 1 63 0
 295 012f 60F401   		mov	r0, #500
 296 0132 060000   		lcall	#_pause
  64:BadgeMuseum.c ****   clear();
 297              		.loc 1 64 0
 298 0135 060000   		lcall	#_screen_clear
  77:BadgeMuseum.c ****       display("ID: %s", my_init.name);
 299              		.loc 1 77 0
 300 0138 CE04     		leasp r14,#4
 301              	.L31
  68:BadgeMuseum.c ****     memset(&their, 0, sizeof(info));
 302              		.loc 1 68 0
 303 013a B1       		mov	r1, #0
 304 013b A210     		mov	r2, #16
 305 013d 600000   		mviw	r0,#_their
  70:BadgeMuseum.c ****     if (y < -35)
 306              		.loc 1 70 0
 307 0140 6D0000   		mviw	r13,#_y
  68:BadgeMuseum.c ****     memset(&their, 0, sizeof(info));
 308              		.loc 1 68 0
 309 0143 060000   		lcall	#_memset
  69:BadgeMuseum.c ****     tilt_get(&x, &y, &z);
 310              		.loc 1 69 0
 311 0146 600000   		mviw	r0,#_x
 312 0149 610000   		mviw	r1,#_y
 313 014c 620000   		mviw	r2,#_z
 314 014f 060000   		lcall	#_tilt_get
  70:BadgeMuseum.c ****     if (y < -35)
 315              		.loc 1 70 0
 316 0152 16DD     		rdlong	r6, r13
 317 0154 372360   		neg	r7, #35
 318 0157 1672     		cmps	r6, r7 wz,wc
 319 0159 430000   		IF_AE	brw	#.L11
  72:BadgeMuseum.c ****       clear();
 320              		.loc 1 72 0
 321 015c 060000   		lcall	#_screen_clear
  73:BadgeMuseum.c ****       leds_set(0b000000);
 322              		.loc 1 73 0
 323 015f B0       		mov	r0, #0
  84:BadgeMuseum.c ****       while(y < -35)
 324              		.loc 1 84 0
 325 0160 3B2360   		neg	r11, #35
  73:BadgeMuseum.c ****       leds_set(0b000000);
 326              		.loc 1 73 0
 327 0163 060000   		lcall	#_leds_set
  74:BadgeMuseum.c ****       screen_autoUpdate(OFF);
 328              		.loc 1 74 0
 329 0166 B0       		mov	r0, #0
 330 0167 060000   		lcall	#_screen_autoUpdate
  75:BadgeMuseum.c ****       char_size(SMALL);
 331              		.loc 1 75 0
 332 016a B0       		mov	r0, #0
 333 016b 060000   		lcall	#_char_size
  76:BadgeMuseum.c ****       cursor(3, 2); 
 334              		.loc 1 76 0
 335 016e A102     		mov	r1, #2
 336 0170 A003     		mov	r0, #3
 337 0172 060000   		lcall	#_cursor
  77:BadgeMuseum.c ****       display("ID: %s", my_init.name);
 338              		.loc 1 77 0
 339 0175 670000   		mviw	r7,#.LC2
 340 0178 660000   		mviw	r6,#_my_init
 341 017b F0100E08 		wrlong	r7, sp
 342 017f 16EF     		wrlong	r6, r14
 343 0181 060000   		lcall	#_display
  78:BadgeMuseum.c ****       cursor(0, 5);
 344              		.loc 1 78 0
 345 0184 A105     		mov	r1, #5
 346 0186 B0       		mov	r0, #0
 347 0187 060000   		lcall	#_cursor
  79:BadgeMuseum.c ****       display("Last Interaction");
 348              		.loc 1 79 0
 349 018a 670000   		mviw	r7,#.LC3
 350 018d F0100E08 		wrlong	r7, sp
 351 0191 060000   		lcall	#_display
  80:BadgeMuseum.c ****       cursor(5, 7);
 352              		.loc 1 80 0
 353 0194 A107     		mov	r1, #7
 354 0196 A005     		mov	r0, #5
 355 0198 060000   		lcall	#_cursor
  81:BadgeMuseum.c ****       display(last.name);
 356              		.loc 1 81 0
 357 019b 660000   		mviw	r6,#_last
 358 019e F0100C08 		wrlong	r6, sp
 359 01a2 060000   		lcall	#_display
  82:BadgeMuseum.c ****       screen_img180();
 360              		.loc 1 82 0
 361 01a5 060000   		lcall	#_screen_img180
  83:BadgeMuseum.c ****       screen_autoUpdate(ON);
 362              		.loc 1 83 0
 363 01a8 A001     		mov	r0, #1
 364 01aa 060000   		lcall	#_screen_autoUpdate
  84:BadgeMuseum.c ****       while(y < -35)
 365              		.loc 1 84 0
 366 01ad 7F11     		brs	#.L12
 367              	.L13
  86:BadgeMuseum.c ****         tilt_get(&x, &y, &z);
 368              		.loc 1 86 0
 369 01af 600000   		mviw	r0,#_x
 370 01b2 610000   		mviw	r1,#_y
 371 01b5 620000   		mviw	r2,#_z
 372 01b8 060000   		lcall	#_tilt_get
  87:BadgeMuseum.c ****         pause(200);
 373              		.loc 1 87 0
 374 01bb A0C8     		mov	r0, #200
 375 01bd 060000   		lcall	#_pause
 376              	.L12
  84:BadgeMuseum.c ****       while(y < -35)
 377              		.loc 1 84 0 discriminator 1
 378 01c0 17DD     		rdlong	r7, r13
 379 01c2 17B2     		cmps	r7, r11 wz,wc
 380 01c4 7CE9     		IF_B 	brs	#.L13
 381 01c6 4F0000   		brw	#.L34
 382              	.L11
  91:BadgeMuseum.c ****     else if (pad(1) == 1 && pad(4) == 1)
 383              		.loc 1 91 0
 384 01c9 A001     		mov	r0, #1
 385 01cb 060000   		lcall	#_pad
 386 01ce 2012     		cmps	r0, #1 wz,wc
 387 01d0 450000   		IF_NE	brw	#.L15
  91:BadgeMuseum.c ****     else if (pad(1) == 1 && pad(4) == 1)
 388              		.loc 1 91 0 is_stmt 0 discriminator 1
 389 01d3 A004     		mov	r0, #4
 390 01d5 060000   		lcall	#_pad
 391 01d8 2012     		cmps	r0, #1 wz,wc
 392 01da 450000   		IF_NE	brw	#.L15
 393              	.LBB10
  93:BadgeMuseum.c ****       clear();
 394              		.loc 1 93 0 is_stmt 1
 395 01dd 060000   		lcall	#_screen_clear
  94:BadgeMuseum.c ****       cursor(3, 2);
 396              		.loc 1 94 0
 397 01e0 A102     		mov	r1, #2
 398 01e2 A003     		mov	r0, #3
 399 01e4 060000   		lcall	#_cursor
  95:BadgeMuseum.c ****       display("Sending...");
 400              		.loc 1 95 0
 401 01e7 670000   		mviw	r7,#.LC4
 402 01ea F0100E08 		wrlong	r7, sp
 403 01ee 060000   		lcall	#_display
  96:BadgeMuseum.c ****       led(4, ON); 
 404              		.loc 1 96 0
 405 01f1 A004     		mov	r0, #4
 406 01f3 A101     		mov	r1, #1
 407 01f5 060000   		lcall	#_led
  97:BadgeMuseum.c ****       led(1, ON);
 408              		.loc 1 97 0
 409 01f8 A001     		mov	r0, #1
 410 01fa A101     		mov	r1, #1
 411 01fc 060000   		lcall	#_led
  98:BadgeMuseum.c ****       rgb(L, BLUE);
 412              		.loc 1 98 0
 413 01ff A04C     		mov	r0, #76
 414 0201 A101     		mov	r1, #1
 415 0203 060000   		lcall	#_rgb
  99:BadgeMuseum.c ****       strcpy(my_init.itime, (char)CNT);
 416              		.loc 1 99 0
 417 0206 670000   		mviw	r7,#_my_init+14
 418 0209 F20002A0 		mov	r1, CNT
 419 020d 31FF40   		and	r1,#255
 420 0210 107C     		rdbyte	r0, r7
 421 0212 060000   		lcall	#_strcpy
 100:BadgeMuseum.c ****       ir_send(&my_init);
 422              		.loc 1 100 0
 423 0215 600000   		mviw	r0,#_my_init
 424 0218 060000   		lcall	#_ir_send
 101:BadgeMuseum.c ****       rgb(L, OFF);
 425              		.loc 1 101 0
 426 021b A04C     		mov	r0, #76
 427 021d B1       		mov	r1, #0
 428 021e 060000   		lcall	#_rgb
 102:BadgeMuseum.c ****       cursor(6, 4);
 429              		.loc 1 102 0
 430 0221 A104     		mov	r1, #4
 431 0223 A006     		mov	r0, #6
 432 0225 060000   		lcall	#_cursor
 103:BadgeMuseum.c ****       display("DONE");
 433              		.loc 1 103 0
 434 0228 660000   		mviw	r6,#.LC5
 435 022b F0100C08 		wrlong	r6, sp
 436 022f 060000   		lcall	#_display
 104:BadgeMuseum.c ****       cursor(3, 6);
 437              		.loc 1 104 0
 438 0232 A106     		mov	r1, #6
 439 0234 A003     		mov	r0, #3
 440 0236 060000   		lcall	#_cursor
 105:BadgeMuseum.c ****       display("Waiting...");      
 441              		.loc 1 105 0
 442 0239 670000   		mviw	r7,#.LC6
 443 023c F0100E08 		wrlong	r7, sp
 444 0240 060000   		lcall	#_display
 106:BadgeMuseum.c ****       led(4, OFF);
 445              		.loc 1 106 0
 446 0243 A004     		mov	r0, #4
 447 0245 B1       		mov	r1, #0
 448 0246 060000   		lcall	#_led
 107:BadgeMuseum.c ****       led(1, OFF);
 449              		.loc 1 107 0
 450 0249 A001     		mov	r0, #1
 451 024b B1       		mov	r1, #0
 452 024c 060000   		lcall	#_led
 110:BadgeMuseum.c ****       int dt = CLKFREQ * 2;
 453              		.loc 1 110 0
 454 024f 670000   		mviw	r7,#__clkfreq
 109:BadgeMuseum.c ****       int t = CNT;
 455              		.loc 1 109 0
 456 0252 F20016A0 		mov	r11, CNT
 457              	.LVL13
 110:BadgeMuseum.c ****       int dt = CLKFREQ * 2;
 458              		.loc 1 110 0
 459 0256 1D7D     		rdlong	r13, r7
 460 0258 2D19     		shl	r13, #1
 461              	.LVL14
 113:BadgeMuseum.c ****       while (check_inbox() == 0)
 462              		.loc 1 113 0
 463 025a 7F0B     		brs	#.L16
 464              	.L17
 115:BadgeMuseum.c ****         if (CNT - t > dt)
 465              		.loc 1 115 0
 466 025c F2000EA0 		mov	r7, CNT
 467 0260 17B1     		sub	r7, r11
 468 0262 17D3     		cmp	r7, r13 wz,wc
 469 0264 410000   		IF_A 	brw	#.L34
 470              	.L16
 113:BadgeMuseum.c ****       while (check_inbox() == 0)
 471              		.loc 1 113 0 discriminator 1
 472 0267 060000   		lcall	#_check_inbox
 473 026a 2002     		cmps	r0, #0 wz,wc
 474 026c 7AEE     		IF_E 	brs	#.L17
 475 026e 4F0000   		brw	#.L35
 476              	.L36
 128:BadgeMuseum.c ****         memset(&last, 0, sizeof(info));
 477              		.loc 1 128 0
 478 0271 B1       		mov	r1, #0
 479 0272 A210     		mov	r2, #16
 480 0274 600000   		mviw	r0,#_last
 481 0277 060000   		lcall	#_memset
 129:BadgeMuseum.c ****         last = their;
 482              		.loc 1 129 0
 483 027a A210     		mov	r2, #16
 484 027c 610000   		mviw	r1,#_their
 485 027f 600000   		mviw	r0,#_last
 486 0282 060000   		lcall	#_memcpy
 130:BadgeMuseum.c ****         ee_save(&their);
 487              		.loc 1 130 0
 488 0285 600000   		mviw	r0,#_their
 489 0288 060000   		lcall	#_ee_save
 131:BadgeMuseum.c ****         cursor(2, 1);
 490              		.loc 1 131 0
 491 028b A101     		mov	r1, #1
 492 028d A002     		mov	r0, #2
 493 028f 060000   		lcall	#_cursor
 132:BadgeMuseum.c ****         display("INTERACTION!");
 494              		.loc 1 132 0
 495 0292 660000   		mviw	r6,#.LC7
 496 0295 F0100C08 		wrlong	r6, sp
 497 0299 060000   		lcall	#_display
 133:BadgeMuseum.c ****         cursor(3, 4);
 498              		.loc 1 133 0
 499 029c A104     		mov	r1, #4
 500 029e A003     		mov	r0, #3
 501 02a0 060000   		lcall	#_cursor
 134:BadgeMuseum.c ****         display("ID: %s", their.name);
 502              		.loc 1 134 0
 503 02a3 670000   		mviw	r7,#.LC2
 504 02a6 660000   		mviw	r6,#_their
 505 02a9 F0100E08 		wrlong	r7, sp
 506 02ad 16EF     		wrlong	r6, r14
 507 02af 060000   		lcall	#_display
 135:BadgeMuseum.c ****         cursor(0, 7);
 508              		.loc 1 135 0
 509 02b2 A107     		mov	r1, #7
 510 02b4 B0       		mov	r0, #0
 511 02b5 060000   		lcall	#_cursor
 136:BadgeMuseum.c ****         display("OSH to Continue.");
 512              		.loc 1 136 0
 513 02b8 670000   		mviw	r7,#.LC8
 514 02bb F0100E08 		wrlong	r7, sp
 515 02bf 060000   		lcall	#_display
 137:BadgeMuseum.c ****         rgb(L, OFF);
 516              		.loc 1 137 0
 517 02c2 A04C     		mov	r0, #76
 518 02c4 B1       		mov	r1, #0
 519 02c5 060000   		lcall	#_rgb
 520              	.L19
 138:BadgeMuseum.c ****         while(pad(6) != 1);
 521              		.loc 1 138 0 discriminator 1
 522 02c8 A006     		mov	r0, #6
 523 02ca 060000   		lcall	#_pad
 524 02cd 2012     		cmps	r0, #1 wz,wc
 525 02cf 75F7     		IF_NE	brs	#.L19
 526 02d1 4F0000   		brw	#.L23
 527              	.L33
 142:BadgeMuseum.c ****       else if (!strcmp(their.email, "DUMP"))
 528              		.loc 1 142 0
 529 02d4 600000   		mviw	r0,#_their+7
 530 02d7 610000   		mviw	r1,#.LC9
 531 02da 060000   		lcall	#_strcmp
 532 02dd 2002     		cmps	r0, #0 wz,wc
 533 02df 450000   		IF_NE	brw	#.L20
 144:BadgeMuseum.c ****         clear();
 534              		.loc 1 144 0
 535 02e2 060000   		lcall	#_screen_clear
 145:BadgeMuseum.c ****         rgb(L, RED);
 536              		.loc 1 145 0
 537 02e5 A04C     		mov	r0, #76
 538 02e7 A104     		mov	r1, #4
 539 02e9 060000   		lcall	#_rgb
 146:BadgeMuseum.c ****         rgb(R, RED);
 540              		.loc 1 146 0
 541 02ec A052     		mov	r0, #82
 542 02ee A104     		mov	r1, #4
 543 02f0 060000   		lcall	#_rgb
 147:BadgeMuseum.c ****         cursor(1, 3);
 544              		.loc 1 147 0
 545 02f3 A103     		mov	r1, #3
 546 02f5 A001     		mov	r0, #1
 547 02f7 060000   		lcall	#_cursor
 148:BadgeMuseum.c ****         display("EEPROM IR Dump");
 548              		.loc 1 148 0
 549 02fa 660000   		mviw	r6,#.LC10
 550 02fd F0100C08 		wrlong	r6, sp
 551 0301 060000   		lcall	#_display
 149:BadgeMuseum.c ****         cursor(3, 5);
 552              		.loc 1 149 0
 553 0304 A105     		mov	r1, #5
 554 0306 A003     		mov	r0, #3
 555 0308 060000   		lcall	#_cursor
 150:BadgeMuseum.c ****         display("Keep badge");
 556              		.loc 1 150 0
 557 030b 670000   		mviw	r7,#.LC11
 558 030e F0100E08 		wrlong	r7, sp
 559 0312 060000   		lcall	#_display
 151:BadgeMuseum.c ****         cursor(1, 6);
 560              		.loc 1 151 0
 561 0315 A106     		mov	r1, #6
 562 0317 A001     		mov	r0, #1
 563 0319 060000   		lcall	#_cursor
 152:BadgeMuseum.c ****         display("facing hotspot");
 564              		.loc 1 152 0
 565 031c 660000   		mviw	r6,#.LC12
 566 031f F0100C08 		wrlong	r6, sp
 567 0323 060000   		lcall	#_display
 153:BadgeMuseum.c ****         ir_txContacts();
 568              		.loc 1 153 0
 569 0326 060000   		lcall	#_ir_txContacts
 154:BadgeMuseum.c ****         clear_inbox();
 570              		.loc 1 154 0
 571 0329 060000   		lcall	#_clear_inbox
 155:BadgeMuseum.c ****         rgb(L, OFF);
 572              		.loc 1 155 0
 573 032c A04C     		mov	r0, #76
 574 032e B1       		mov	r1, #0
 575 032f 060000   		lcall	#_rgb
 156:BadgeMuseum.c ****         rgb(R, OFF);
 576              		.loc 1 156 0
 577 0332 A052     		mov	r0, #82
 578 0334 B1       		mov	r1, #0
 579 0335 060000   		lcall	#_rgb
 157:BadgeMuseum.c ****         pause(200);
 580              		.loc 1 157 0
 581 0338 A0C8     		mov	r0, #200
 582 033a 060000   		lcall	#_pause
 583 033d 4F0000   		brw	#.L34
 584              	.L20
 162:BadgeMuseum.c ****         rgb(L, OFF);
 585              		.loc 1 162 0
 586 0340 A04C     		mov	r0, #76
 587 0342 B1       		mov	r1, #0
 588 0343 060000   		lcall	#_rgb
 163:BadgeMuseum.c ****         rgb(R, OFF);
 589              		.loc 1 163 0
 590 0346 A052     		mov	r0, #82
 591 0348 B1       		mov	r1, #0
 592 0349 060000   		lcall	#_rgb
 593 034c 4F0000   		brw	#.L31
 594              	.LVL15
 595              	.L15
 596              	.LBE10
 166:BadgeMuseum.c ****     else if(check_inbox() == 1)
 597              		.loc 1 166 0
 598 034f 060000   		lcall	#_check_inbox
 599 0352 2012     		cmps	r0, #1 wz,wc
 600 0354 450000   		IF_NE	brw	#.L21
 168:BadgeMuseum.c ****       clear();
 601              		.loc 1 168 0
 602 0357 060000   		lcall	#_screen_clear
 169:BadgeMuseum.c ****       message_get(&their);
 603              		.loc 1 169 0
 604 035a 600000   		mviw	r0,#_their
 605 035d 060000   		lcall	#_message_get
 170:BadgeMuseum.c ****       if (!strcmp(their.email, "INIT"))
 606              		.loc 1 170 0
 607 0360 600000   		mviw	r0,#_their+7
 608 0363 610000   		mviw	r1,#.LC13
 609 0366 060000   		lcall	#_strcmp
 610 0369 2002     		cmps	r0, #0 wz,wc
 611 036b 450000   		IF_NE	brw	#.L31
 612              	.LBB11
 172:BadgeMuseum.c ****         memset(&last, 0, sizeof(info));
 613              		.loc 1 172 0
 614 036e B1       		mov	r1, #0
 615 036f A210     		mov	r2, #16
 616 0371 600000   		mviw	r0,#_last
 617 0374 060000   		lcall	#_memset
 173:BadgeMuseum.c ****         last = their;
 618              		.loc 1 173 0
 619 0377 A210     		mov	r2, #16
 620 0379 610000   		mviw	r1,#_their
 621 037c 600000   		mviw	r0,#_last
 622 037f 060000   		lcall	#_memcpy
 174:BadgeMuseum.c ****         ee_save(&their);
 623              		.loc 1 174 0
 624 0382 600000   		mviw	r0,#_their
 625 0385 060000   		lcall	#_ee_save
 175:BadgeMuseum.c ****         cursor(2, 1);
 626              		.loc 1 175 0
 627 0388 A101     		mov	r1, #1
 628 038a A002     		mov	r0, #2
 629 038c 060000   		lcall	#_cursor
 176:BadgeMuseum.c ****         display("INTERACTION!");
 630              		.loc 1 176 0
 631 038f 670000   		mviw	r7,#.LC7
 632 0392 F0100E08 		wrlong	r7, sp
 633 0396 060000   		lcall	#_display
 177:BadgeMuseum.c ****         rgb(L, BLUE);
 634              		.loc 1 177 0
 635 0399 A04C     		mov	r0, #76
 636 039b A101     		mov	r1, #1
 637 039d 060000   		lcall	#_rgb
 178:BadgeMuseum.c ****         strcpy(my_resp.itime, (char)CNT);
 638              		.loc 1 178 0
 639 03a0 F20002A0 		mov	r1, CNT
 640 03a4 31FF40   		and	r1,#255
 641 03a7 10CC     		rdbyte	r0, r12
 642 03a9 060000   		lcall	#_strcpy
 179:BadgeMuseum.c ****         ir_send(&my_resp);
 643              		.loc 1 179 0
 644 03ac 600000   		mviw	r0,#_my_resp
 645 03af 060000   		lcall	#_ir_send
 180:BadgeMuseum.c ****         rgb(L, OFF);
 646              		.loc 1 180 0
 647 03b2 A04C     		mov	r0, #76
 648 03b4 B1       		mov	r1, #0
 649 03b5 060000   		lcall	#_rgb
 181:BadgeMuseum.c ****         cursor(3, 4);
 650              		.loc 1 181 0
 651 03b8 A104     		mov	r1, #4
 652 03ba A003     		mov	r0, #3
 653 03bc 060000   		lcall	#_cursor
 182:BadgeMuseum.c ****         display("ID: %s", their.name);
 654              		.loc 1 182 0
 655 03bf 660000   		mviw	r6,#.LC2
 656 03c2 670000   		mviw	r7,#_their
 657 03c5 F0100C08 		wrlong	r6, sp
 658 03c9 17EF     		wrlong	r7, r14
 659 03cb 060000   		lcall	#_display
 183:BadgeMuseum.c ****         cursor(0, 7);
 660              		.loc 1 183 0
 661 03ce A107     		mov	r1, #7
 662 03d0 B0       		mov	r0, #0
 663 03d1 060000   		lcall	#_cursor
 184:BadgeMuseum.c ****         display("OSH to Continue.");
 664              		.loc 1 184 0
 665 03d4 660000   		mviw	r6,#.LC8
 666 03d7 F0100C08 		wrlong	r6, sp
 667 03db 060000   		lcall	#_display
 185:BadgeMuseum.c ****         rgb(L, OFF);
 668              		.loc 1 185 0
 669 03de A04C     		mov	r0, #76
 670 03e0 B1       		mov	r1, #0
 671 03e1 060000   		lcall	#_rgb
 187:BadgeMuseum.c ****         int dt = CLKFREQ * 2;
 672              		.loc 1 187 0
 673 03e4 670000   		mviw	r7,#__clkfreq
 186:BadgeMuseum.c ****         int t = CNT;
 674              		.loc 1 186 0
 675 03e7 F20016A0 		mov	r11, CNT
 676              	.LVL16
 187:BadgeMuseum.c ****         int dt = CLKFREQ * 2;
 677              		.loc 1 187 0
 678 03eb 1D7D     		rdlong	r13, r7
 679 03ed 2D19     		shl	r13, #1
 680              	.LVL17
 188:BadgeMuseum.c ****         while (pad(6) != 1)
 681              		.loc 1 188 0
 682 03ef 7F0A     		brs	#.L22
 683              	.L24
 190:BadgeMuseum.c ****           if (CNT - t > dt)
 684              		.loc 1 190 0
 685 03f1 F2000EA0 		mov	r7, CNT
 686 03f5 17B1     		sub	r7, r11
 687 03f7 17D3     		cmp	r7, r13 wz,wc
 688 03f9 7109     		IF_A 	brs	#.L23
 689              	.L22
 188:BadgeMuseum.c ****         while (pad(6) != 1)
 690              		.loc 1 188 0 discriminator 1
 691 03fb A006     		mov	r0, #6
 692 03fd 060000   		lcall	#_pad
 693 0400 2012     		cmps	r0, #1 wz,wc
 694 0402 75ED     		IF_NE	brs	#.L24
 695              	.LVL18
 696              	.L23
 195:BadgeMuseum.c ****         rgb(R, OFF);
 697              		.loc 1 195 0
 698 0404 A052     		mov	r0, #82
 699 0406 B1       		mov	r1, #0
 700 0407 060000   		lcall	#_rgb
 701              	.L34
 196:BadgeMuseum.c ****         clear();
 702              		.loc 1 196 0
 703 040a 060000   		lcall	#_screen_clear
 704 040d 4F0000   		brw	#.L31
 705              	.L21
 706              	.LBE11
 201:BadgeMuseum.c ****       char_size(BIG);
 707              		.loc 1 201 0
 708 0410 A001     		mov	r0, #1
 709 0412 060000   		lcall	#_char_size
 202:BadgeMuseum.c ****       cursor(0, 0); 
 710              		.loc 1 202 0
 711 0415 B1       		mov	r1, #0
 712 0416 B0       		mov	r0, #0
 713 0417 060000   		lcall	#_cursor
 203:BadgeMuseum.c ****       display("%s", my_init.name);
 714              		.loc 1 203 0
 715 041a 670000   		mviw	r7,#.LC14
 716 041d 660000   		mviw	r6,#_my_init
 717 0420 F0100E08 		wrlong	r7, sp
 718 0424 16EF     		wrlong	r6, r14
 719 0426 060000   		lcall	#_display
 204:BadgeMuseum.c ****       char_size(SMALL);
 720              		.loc 1 204 0
 721 0429 B0       		mov	r0, #0
 722 042a 060000   		lcall	#_char_size
 205:BadgeMuseum.c ****       cursor(4, 6);
 723              		.loc 1 205 0
 724 042d A106     		mov	r1, #6
 725 042f A004     		mov	r0, #4
 726 0431 060000   		lcall	#_cursor
 206:BadgeMuseum.c ****       display("...is ready.");
 727              		.loc 1 206 0
 728 0434 670000   		mviw	r7,#.LC15
 729 0437 F0100E08 		wrlong	r7, sp
 730 043b 060000   		lcall	#_display
 207:BadgeMuseum.c ****       leds_set(0b101101);
 731              		.loc 1 207 0
 732 043e A02D     		mov	r0, #45
 733 0440 060000   		lcall	#_leds_set
 208:BadgeMuseum.c ****       pause(100);
 734              		.loc 1 208 0
 735 0443 A064     		mov	r0, #100
 736 0445 060000   		lcall	#_pause
 737 0448 4F0000   		brw	#.L31
 738              	.LVL19
 739              	.L35
 740              	.LBB12
 124:BadgeMuseum.c ****       clear();
 741              		.loc 1 124 0
 742 044b 060000   		lcall	#_screen_clear
 125:BadgeMuseum.c ****       message_get(&their);
 743              		.loc 1 125 0
 744 044e 600000   		mviw	r0,#_their
 745 0451 060000   		lcall	#_message_get
 126:BadgeMuseum.c ****       if (!strcmp(their.email, "RESP"))
 746              		.loc 1 126 0
 747 0454 600000   		mviw	r0,#_their+7
 748 0457 610000   		mviw	r1,#.LC16
 749 045a 060000   		lcall	#_strcmp
 750 045d 2002     		cmps	r0, #0 wz,wc
 751 045f 450000   		IF_NE	brw	#.L33
 752 0462 4F0000   		brw	#.L36
 753              	.LBE12
 754              	.LFE1
 755              		.global	_heldatstart
 756              		.section	.bss
 757              		.balign	4
 758              	_heldatstart
 759 0000 00000000 		.zero	4
 760              		.comm	_z,4,4
 761              		.comm	_y,4,4
 762              		.comm	_x,4,4
 763              		.comm	_port,4,4
 764              		.comm	_handshake,5,4
 765              		.global	_id_address
 766              		.data
 767 00d1 000000   		.balign	4
 768              	_id_address
 769 00d4 37FF0000 		long	65335
 770              		.global	_last
 771              		.balign	4
 772              	_last
 773 00d8 2000     		.ascii " \0"
 774 00da 00000000 		.zero	5
 774      00
 775 00df 2000     		.ascii " \0"
 776 00e1 00000000 		.zero	5
 776      00
 777 00e6 00       		byte	0
 778 00e7 00       		byte	0
 779              		.comm	_their,16,4
 780              		.global	_my_resp
 781              		.balign	4
 782              	_my_resp
 783 00e8 2000     		.ascii " \0"
 784 00ea 00000000 		.zero	5
 784      00
 785 00ef 52455350 		.ascii "RESP\0"
 785      00
 786 00f4 0000     		.zero	2
 787 00f6 00       		byte	0
 788 00f7 00       		byte	0
 789              		.global	_my_init
 790              		.balign	4
 791              	_my_init
 792 00f8 2000     		.ascii " \0"
 793 00fa 00000000 		.zero	5
 793      00
 794 00ff 494E4954 		.ascii "INIT\0"
 794      00
 795 0104 0000     		.zero	2
 796 0106 00       		byte	0
 797 0107 00       		byte	0
 798              		.global	_my
 799              		.balign	4
 800              	_my
 801 0108 2000     		.ascii " \0"
 802 010a 00000000 		.zero	5
 802      00
 803 010f 494E464F 		.ascii "INFO\0"
 803      00
 804 0114 0000     		.zero	2
 805 0116 00       		byte	0
 806 0117 00       		byte	0
 876              	.Letext0
 877              		.file 2 "C:/Users/Sebastian/Documents/SimpleIDE/Learn/Simple Libraries/TextDevices/libsimpletext/s
 878              		.file 3 "c:\\program files (x86)\\simpleide\\propeller-gcc\\bin\\../lib/gcc/propeller-elf/4.6.1/..
 879              		.file 4 "c:\\program files (x86)\\simpleide\\propeller-gcc\\bin\\../lib/gcc/propeller-elf/4.6.1/..
 880              		.file 5 "C:/Users/Sebastian/Documents/SimpleIDE/Learn/Simple Libraries/TextDevices/libfdserial/fds
 881              		.file 6 "C:/Users/Sebastian/Documents/GitHub/badgemuseumsim/libbadgealpha/badgealpha.h"
 882              		.file 7 "c:\\program files (x86)\\simpleide\\propeller-gcc\\bin\\../lib/gcc/propeller-elf/4.6.1/..
DEFINED SYMBOLS
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:2      .text:00000000 .Ltext0
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:4      .text:00000000 _screen_img180
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:5      .text:00000000 .LFB2
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:8      .text:00000000 L0
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:35     .text:00000015 .L3
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:102    .text:00000067 .L2
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:126    .text:00000076 .LFE2
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:129    .data:00000000 .LC0
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:132    .data:00000010 .LC1
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:135    .data:0000001c .LC2
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:138    .data:00000024 .LC3
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:141    .data:00000038 .LC4
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:144    .data:00000044 .LC5
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:147    .data:0000004c .LC6
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:150    .data:00000058 .LC7
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:153    .data:00000068 .LC8
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:156    .data:0000007c .LC9
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:159    .data:00000084 .LC10
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:162    .data:00000094 .LC11
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:165    .data:000000a0 .LC12
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:168    .data:000000b0 .LC13
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:171    .data:000000b8 .LC14
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:174    .data:000000bc .LC15
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:177    .data:000000cc .LC16
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:181    .text:00000076 _main
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:182    .text:00000076 .LFB1
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:768    .data:000000d4 _id_address
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:800    .data:00000108 _my
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:791    .data:000000f8 _my_init
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:782    .data:000000e8 _my_resp
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:758    .bss:00000000 _heldatstart
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:301    .text:0000013a .L31
                            *COM*:00000010 _their
                            *COM*:00000004 _y
                            *COM*:00000004 _x
                            *COM*:00000004 _z
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:772    .data:000000d8 _last
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:382    .text:000001c9 .L11
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:476    .text:00000271 .L36
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:527    .text:000002d4 .L33
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:584    .text:00000340 .L20
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:595    .text:0000034f .L15
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:696    .text:00000404 .L23
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:701    .text:0000040a .L34
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:705    .text:00000410 .L21
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:739    .text:0000044b .L35
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:754    .text:00000465 .LFE1
                            *COM*:00000004 _port
                            *COM*:00000005 _handshake
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:808    .debug_frame:00000000 .Lframe0
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:876    .text:00000465 .Letext0
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:884    .debug_info:00000000 .Ldebug_info0
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:1470   .debug_abbrev:00000000 .Ldebug_abbrev0
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:1788   .debug_loc:00000000 .LLST0
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:1801   .debug_loc:00000020 .LLST1
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:1812   .debug_loc:0000003e .LLST2
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:1871   .debug_loc:0000009a .LLST3
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:1878   .debug_loc:000000ad .LLST4
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:1898   .debug_loc:000000cd .LLST5
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:1928   .debug_loc:00000105 .LLST6
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:1939   .debug_loc:00000123 .LLST7
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:1972   .debug_loc:00000157 .LLST8
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:1988   .debug_loc:00000181 .LLST9
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:2004   .debug_loc:000001ab .LLST10
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:2022   .debug_loc:000001d7 .LLST11
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:2029   .debug_loc:000001ea .LLST12
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:2036   .debug_loc:000001fd .LLST13
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:2047   .debug_loc:0000021b .LLST14
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:2058   .debug_loc:00000239 .LLST15
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:2084   .debug_ranges:00000000 .Ldebug_ranges0
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:2116   .debug_line:00000000 .Ldebug_line0
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:2118   .debug_str:00000000 .LASF2
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:2120   .debug_str:0000000c .LASF1
C:\Users\SEBAST~1\AppData\Local\Temp\ccc877uZ.s:2122   .debug_str:00000017 .LASF0

UNDEFINED SYMBOLS
_screen_getBuffer
_screen_autoUpdate
_badge_setup
_simpleterm_close
_leds_set
_ee_getStr
_strcpy
_pause
_char_size
_cursor
_display
_pad
_screen_clear
_ee_wipe
_ir_start
_memset
_tilt_get
_led
_rgb
CNT
_ir_send
__clkfreq
_check_inbox
_memcpy
_ee_save
_strcmp
_ir_txContacts
_clear_inbox
_message_get
