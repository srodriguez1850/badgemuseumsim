//
// automatically generated by spin2cpp v1.93 on Tue Aug 11 09:49:47 2015
// spin2cpp --ccode --main demo.spin 
//

//   MMA7660 accelerometer
// =================================================================================================
//
//   File....... light.spin
//   Purpose.... Charlieplex driver for Parallax Open Source eBadge
//   Author..... Jon "JonnyMac" McPhalen
//               Copyright (C) 2015 Jon McPhalen
//               -- see below for terms of use
//   E-mail..... jon@jonmcphalen.com
//   Started....
//   Updated.... 06 JUL 2015
//
// =================================================================================================
/* 

   Blue LEDs (enable bits in ledbits.byte[0] as %00543210)      

       B5   B4   B3   B2   B1   B0                                      Layout       
       ---  ---  ---  ---  ---  ---                              --------------------
   P8   Z    Z    H    L    H    L                               B5                B0
   P7   L    H    L    Z    Z    H                               B4                B1
   P6   H    L    Z    H    L    Z                               B3                B2


   RGB LEDs (enable bits in ledbits.byte[1] as %00RGBrgb)

       R2   G2   B2   r1   g1   b1                                      Layout   
       ---  ---  ---  ---  ---  ---                              -------------------- 
   P3   H    Z    L    L    Z    H                                   G2        g1  
   P2   L    L    Z    H    H    Z                                                   
   P1   Z    H    H    Z    L    L                                 R2  B2    r1  b1

 */
#include <propeller.h>
#include "badgealpha.h"

#ifdef __GNUC__
#define INLINE__ static inline
//define PostEffect__(X, Y) __extension__({ int32_t tmp__ = (X); (X) = (Y); tmp__; })
#else
#define INLINE__ static
static int32_t tmp__;
#define PostEffect__(X, Y) (tmp__ = (X), (X) = (Y), tmp__)
#define waitcnt(n) _waitcnt(n)
#define coginit(id, code, par) _coginit((unsigned)(par)>>2, (unsigned)(code)>>2, id)
#define cognew(code, par) coginit(0x8, (code), (par))
#define cogstop(i) _cogstop(i)
#endif

static uint8_t leddat[] = {
  0xf0, 0xd7, 0xbc, 0xa0, 0x6b, 0xd8, 0xbc, 0x08, 0x6c, 0xbc, 0xbc, 0xa0, 0x1f, 0xbc, 0xfc, 0x60, 
  0x6c, 0xbe, 0xbc, 0xa0, 0x08, 0xbe, 0xfc, 0x28, 0x1f, 0xbe, 0xfc, 0x60, 0x04, 0xd6, 0xfc, 0x80, 
  0x6b, 0xc0, 0xbc, 0x08, 0x00, 0xd6, 0xfc, 0xa0, 0xf0, 0xd7, 0x3c, 0x08, 0x60, 0xc2, 0xbc, 0xa0, 
  0xf1, 0xc3, 0xbc, 0x80, 0x00, 0xc4, 0xfc, 0xa0, 0xf0, 0xc7, 0xbc, 0x08, 0x01, 0xc8, 0xfc, 0xa0, 
  0x62, 0xc8, 0xbc, 0x2c, 0x64, 0xc6, 0x3c, 0x61, 0x00, 0xca, 0xfc, 0xa0, 0x00, 0xcc, 0xfc, 0xa0, 
  0x2f, 0x00, 0x4c, 0x5c, 0x18, 0xd6, 0xfc, 0xa0, 0x62, 0xd6, 0xbc, 0x80, 0x6b, 0x00, 0x3c, 0x5c, 
  0x1e, 0x00, 0x7c, 0x5c, 0x21, 0x00, 0x7c, 0x5c, 0x24, 0x00, 0x7c, 0x5c, 0x27, 0x00, 0x7c, 0x5c, 
  0x2a, 0x00, 0x7c, 0x5c, 0x2d, 0x00, 0x7c, 0x5c, 0x02, 0xca, 0xfc, 0xa0, 0x06, 0xcc, 0xfc, 0xa0, 
  0x2f, 0x00, 0x7c, 0x5c, 0x04, 0xca, 0xfc, 0xa0, 0x05, 0xcc, 0xfc, 0xa0, 0x2f, 0x00, 0x7c, 0x5c, 
  0x01, 0xca, 0xfc, 0xa0, 0x05, 0xcc, 0xfc, 0xa0, 0x2f, 0x00, 0x7c, 0x5c, 0x04, 0xca, 0xfc, 0xa0, 
  0x06, 0xcc, 0xfc, 0xa0, 0x2f, 0x00, 0x7c, 0x5c, 0x02, 0xca, 0xfc, 0xa0, 0x03, 0xcc, 0xfc, 0xa0, 
  0x2f, 0x00, 0x7c, 0x5c, 0x01, 0xca, 0xfc, 0xa0, 0x03, 0xcc, 0xfc, 0xa0, 0x08, 0xc8, 0xfc, 0x2c, 
  0x00, 0xce, 0xfc, 0xa0, 0x00, 0xd0, 0xfc, 0xa0, 0x64, 0xc6, 0x3c, 0x61, 0x4e, 0x00, 0x4c, 0x5c, 
  0x37, 0xd6, 0xfc, 0xa0, 0x62, 0xd6, 0xbc, 0x80, 0x6b, 0x00, 0x3c, 0x5c, 0x3d, 0x00, 0x7c, 0x5c, 
  0x40, 0x00, 0x7c, 0x5c, 0x43, 0x00, 0x7c, 0x5c, 0x46, 0x00, 0x7c, 0x5c, 0x49, 0x00, 0x7c, 0x5c, 
  0x4c, 0x00, 0x7c, 0x5c, 0x04, 0xce, 0xfc, 0xa0, 0x05, 0xd0, 0xfc, 0xa0, 0x4e, 0x00, 0x7c, 0x5c, 
  0x02, 0xce, 0xfc, 0xa0, 0x03, 0xd0, 0xfc, 0xa0, 0x4e, 0x00, 0x7c, 0x5c, 0x02, 0xce, 0xfc, 0xa0, 
  0x06, 0xd0, 0xfc, 0xa0, 0x4e, 0x00, 0x7c, 0x5c, 0x01, 0xce, 0xfc, 0xa0, 0x05, 0xd0, 0xfc, 0xa0, 
  0x4e, 0x00, 0x7c, 0x5c, 0x01, 0xce, 0xfc, 0xa0, 0x03, 0xd0, 0xfc, 0xa0, 0x4e, 0x00, 0x7c, 0x5c, 
  0x04, 0xce, 0xfc, 0xa0, 0x06, 0xd0, 0xfc, 0xa0, 0x00, 0xec, 0xff, 0xa0, 0x5e, 0xca, 0xbc, 0x2c, 
  0x65, 0xd2, 0xbc, 0xa0, 0x5e, 0xcc, 0xbc, 0x2c, 0x66, 0xd4, 0xbc, 0xa0, 0x5f, 0xce, 0xbc, 0x2c, 
  0x67, 0xd2, 0xbc, 0x68, 0x5f, 0xd0, 0xbc, 0x2c, 0x68, 0xd4, 0xbc, 0x68, 0x69, 0xe8, 0xbf, 0xa0, 
  0x6a, 0xec, 0xbf, 0xa0, 0x01, 0xc4, 0xfc, 0x80, 0x06, 0xc4, 0x7c, 0x87, 0x00, 0xc4, 0xe8, 0xa0, 
  0x60, 0xc2, 0xbc, 0xf8, 0x0e, 0x00, 0x7c, 0x5c, 
};

static light badgeLight;
static light *self;

int32_t 	cpcog;

int32_t light_start(void)
{
  self = &badgeLight;
  // Start conference badge charlieplex driver
  // stop cog if running
  light_stop();
  // base of blue group
  ((uint8_t *)(int32_t)(&self->ledbits))[0] = BLU_CP0;
  // base of rgb group
  ((uint8_t *)(int32_t)(&self->ledbits))[1] = RGB_CP0;
  // update LEDs at 300Hz 
  self->cycleticks = (CLKFREQ / 300) / 6;
  // start pasm cog
  self->cog = cognew((int32_t)(&(*(int32_t *)&leddat[0])), (int32_t)(&self->ledbits)) + 1;
  return self->cog;
}

void light_stop(void)
{
  // Stops charlieplex cog if running
  if (self->cog) {
    // running?
    // yes, stop it
    cogstop((self->cog - 1));
    // mark stopped
    self->cog = 0;
  }
  // clear led bits (for re-start)
  self->ledbits = 0;
}

void led_on(int32_t n)
{
  // Turns off selected blue LED, 0..5
  if ((n >= 0) && (n <= 5)) {
    // turn it on  
    ((uint8_t *)(int32_t)(&self->ledbits))[0] = ((uint8_t *)(int32_t)(&self->ledbits))[0] | (1 << n);
  }
}

void led_off(int32_t n)
{
  // Turns off selected blue LED, 0..5
  if ((n >= 0) && (n <= 5)) {
    // turn it off
    ((uint8_t *)(int32_t)(&self->ledbits))[0] = ((uint8_t *)(int32_t)(&self->ledbits))[0] & (~(1 << n));
  }
}

void led(int n, int state)
{
  state ? led_on(n) : led_off(n);
}  

void leds_set(int32_t bits)
{
  // update all blue LEDs
  ((uint8_t *)(int32_t)(&self->ledbits))[0] = bits & 0x3f;
}

void rgb(int side, int color)
{
  color &= 0b111;
  if(side == L)
  {
    light_set_rgb2(color);
  }    
  else if(side == R)
  {  
    light_set_rgb1(color);
  }    
}  

void light_set_rgb1(int32_t bits)
{
  ((uint8_t *)(int32_t)(&self->ledbits))[1] = (((uint8_t *)(int32_t)(&self->ledbits))[1] & 0x38) | (bits & 0x7);
}

void light_set_rgb2(int32_t bits)
{
  ((uint8_t *)(int32_t)(&self->ledbits))[1] = (((uint8_t *)(int32_t)(&self->ledbits))[1] & 0x7) | ((bits & 0x7) << 3);
}

void rgbs_set(int32_t bits2, int32_t bits1)
{
  ((uint8_t *)(int32_t)(&self->ledbits))[1] = ((bits2 & 0x7) << 3) | (bits1 & 0x7);
}

void light_set_rgb(int32_t bits)
{
  // update all rgb LEDs
  ((uint8_t *)(int32_t)(&self->ledbits))[1] = bits & 0x3f;
}

void light_set_all(int32_t bits)
{
  // Allows simulateous control of all LEDs
  // -- use 16-bit value as %00rgbrgb_00bbbbbb
  //    * upper byte holds rgb LED bits (x2), lower byte holds blue LED bits
  self->ledbits = bits;
}

void light_clear(void)
{
  // Clears all LEDs
  // clear rgb and blue leds
  self->ledbits = 0;
}

void set_1_blue(int32_t idx)
{
  int32_t result = 0;
  // LOCKED 30 JUN 2015  
  // Set one of the six blue LEDs
  // -- connections designed for Charlieplexing
  //    * make one high, one low, the other high-z (input)
  // -- for multiple LEDs use Charlieplex driver methods
  
  if (cpcog) {
    // Charlieplex driver loaded?
    if ((idx >= BLUE_0) && (idx <= BLUE_5)) {
      // valid element?
      // set via mask
      led_on((1 << idx));
    } else {
      // clear all 
      leds_set(0b000000);
    }
    return;
  }
  // if no driver loaded, use direct control
  if (idx == BLUE_0) {
    // CP2 = L, CP1 = H, CP0 = Z     
    OUTA = ((OUTA & 0xfffffe3f) | 0x80);
    DIRA = ((DIRA & 0xfffffe3f) | 0x180);
  } else if (idx == BLUE_1) {
    // CP2 = H, CP1 = Z, CP0 = L    
    OUTA = ((OUTA & 0xfffffe3f) | 0x100);
    DIRA = ((DIRA & 0xfffffe3f) | 0x140);
  } else if (idx == BLUE_2) {
    // CP2 = L, CP1 = Z, CP0 = H 
    OUTA = ((OUTA & 0xfffffe3f) | 0x40);
    DIRA = ((DIRA & 0xfffffe3f) | 0x140);
  } else if (idx == BLUE_3) {
    // CP2 = H, CP1 = L, CP0 = Z  
    OUTA = ((OUTA & 0xfffffe3f) | 0x100);
    DIRA = ((DIRA & 0xfffffe3f) | 0x180);
  } else if (idx == BLUE_4) {
    // CP2 = Z, CP1 = H, CP0 = L 
    OUTA = ((OUTA & 0xfffffe3f) | 0x80);
    DIRA = ((DIRA & 0xfffffe3f) | 0xc0);
  } else if (idx == BLUE_5) {
    // CP2 = Z, CP1 = L, CP0 = H
    OUTA = ((OUTA & 0xfffffe3f) | 0x40);
    DIRA = ((DIRA & 0xfffffe3f) | 0xc0);
  } else if (1) {
    // disable all
    OUTA &= ~(7<<BLU_CP0);
    DIRA &= ~(7<<BLU_CP0);
  }
}

void set_1_rgb(int idx)
{
  int32_t result = 0;
  // LOCKED 30 JUN 2015  
  // Set one of the LEDs within the RGB modules
  // -- connections designed for Charlieplexing
  //    * make one high, one low, the other high-z (input)
  // -- for multiple LEDs/colors use Charlieplex driver methods
  if (cpcog) {
    // Charlieplex driver loaded?      
    if ((idx >= RGB_B1) && (idx <= RGB_R2)) {
      // valid element?                  
      // set via mask                    
      light_set_rgb((1 << idx));
    } else {
      // clear all                       
      light_set_rgb(0);
    }
    return;
  }
  // if no driver loaded, use direct control
  if (idx == RGB_B1) {
    // CP2 = H, CP1 = Z, CP0 = L 
    OUTA = ((OUTA & 0xfffffff1) | 0x8);
    DIRA = ((DIRA & 0xfffffff1) | 0xa);
  } else if (idx == RGB_G1) {
    // CP2 = Z, CP1 = H, CP0 = L 
    OUTA = ((OUTA & 0xfffffff1) | 0x4);
    DIRA = ((DIRA & 0xfffffff1) | 0x6);
  } else if (idx == RGB_R1) {
    // CP2 = L, CP1 = H, CP0 = Z     
    OUTA = ((OUTA & 0xfffffff1) | 0x4);
    DIRA = ((DIRA & 0xfffffff1) | 0xc);
  } else if (idx == RGB_B2) {
    // CP2 = L, CP1 = Z, CP0 = H  
    OUTA = ((OUTA & 0xfffffff1) | 0x2);
    DIRA = ((DIRA & 0xfffffff1) | 0xa);
  } else if (idx == RGB_G2) {
    // CP2 = Z, CP1 = L, CP0 = H 
    OUTA = ((OUTA & 0xfffffff1) | 0x2);
    DIRA = ((DIRA & 0xfffffff1) | 0x6);
  } else if (idx == RGB_R2) {
    // CP2 = H, CP1 = L, CP0 = Z
    OUTA = ((OUTA & 0xfffffff1) | 0x8);
    DIRA = ((DIRA & 0xfffffff1) | 0xc);
  } else if (1) {
    // disable all
    OUTA &= ~(7<<RGB_CP0);
    DIRA &= ~(7<<RGB_CP0);
  }
}



/* 

  Copyright (C) 2015 Jon McPhalen

  Terms of Use: MIT License

  Permission is hereby granted, free of charge, to any person obtaining a copy of this
  software and associated documentation files (the "Software"), to deal in the Software
  without restriction, including without limitation the rights to use, copy, modify,
  merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to the following
  conditions:

  The above copyright notice and this permission notice shall be included in all copies
  or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
  PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 */
