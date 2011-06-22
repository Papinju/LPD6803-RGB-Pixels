/*
 * arduino serial-i2c-gateway, Copyright (C) 2011 michael vogt <michu@neophob.com>
 *  
 * This file is part of neorainbowduino.
 *
 * neorainbowduino is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * neorainbowduino is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Iwnc., 675 Mass Ave, Cambridge, MA 02139, USA.
 * 	
 */

#include <TimerOne.h>
#include "Particle.h"
#include "LPD6803.h"

#define PIXELS 20

// Choose which 2 pins you will use for output.
// Can be any valid output pins.
int dataPin = 2;       // 'green' wire
int clockPin = 3;      // 'blue' wire
// Don't forget to connect 'blue' to ground and 'red' to +5V

Particles parts;
int frame;

//initialize strip with 20 leds
LPD6803 strip = LPD6803(PIXELS, dataPin, clockPin);

void setup() {
  pinMode(13, OUTPUT);
  randomSeed(analogRead(0));

  strip.setCPUmax(50);  // start with 50% CPU usage. up this if the strand flickers or is slow

  // Start up the LED counter
  strip.begin();

  // Update the strip, to start they are all 'off'
  strip.show();
}


void colorWipe(uint16_t c, uint8_t wait) {
  int i;
 
  for (i=0; i < strip.numPixels(); i++) {
      strip.setPixelColor(i, c);
      strip.show();
      delay(wait);
  }
}
 
/* Helper functions */
 
// Create a 15 bit color value from R,G,B
unsigned int Color(byte r, byte g, byte b) {
  //Take the lowest 5 bits of each value and append them end to end
  return( ((unsigned int)g & 0x1F )<<10 | ((unsigned int)b & 0x1F)<<5 | (unsigned int)r & 0x1F);
}



void loop() {
  if(frame % 10 == 0) {
      parts.createExplosion(rand() % PIXELS, 2);
  }

  parts.moveParticles();
  drawParticles(); 
  
  frame++;
}

// This is a function to draw all of the particles to the screen.
// You may as well copypasta this into whatever sketch you use it on.
void drawParticles() {
  byte i;
    
  for (i = 0; i < parts.getActiveParticles(); i++) {
    byte x = parts.particles[i].x;
    if ((x < 0) || (x > PIXELS))
      continue;

    byte velX = parts.particles[i].velX;   
    if (velX > 0) {
      velX++;
    } else {
      velX--;
    }
        
    strip.setPixelColor(x, Color(222,33,123));
    strip.setPixelColor(x- (velX/5), Color(111,16,66));
    //glcd.setpixel(x, y, BLACK);
    //glcd.setpixel(x - (velX/5), y - (velY/5), WHITE); // uncomment for trail-deleting action!
    // NOTE: this doesn't remove pixels of deleted particles
  }
  
  //show the buffer asap
  strip.doSwapBuffersAsap(0);
}


