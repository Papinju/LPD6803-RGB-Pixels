/*      Particle.h
 *      
 *      Floppyright 2010 Tuna <tuna@supertunaman.com>
 *      2011 michael vogt <michu@neophob.com>
 *      
 *      A particle system for the Arduino and any given graphic LCD.
 *      
 */

#ifndef PARTICLE_H
#define PARTICLE_H

#include "WProgram.h"

#define MAX_PARTICLES 14
#define SCREEN_WIDTH 20

/* The Particle class has four members; x and y coordinates, and then
 * x and y velocity. The velocity is a number between -25 and 25, which is 
 * divided by 5 as an integer to come out to some number between -5 and 
 * 5. This is so that the particle will actually slow to a halt over a 
 * longer period of time as the velocity is added to or subtracted from, 
 * one moveParticles() at a time. */
class Particle {
    public:
        byte x;
        byte velX;
};

class Particles {
    public:
        Particles();
        ~Particles();
        void moveParticles();
        void createExplosion(byte x, byte num_parts);
        byte getActiveParticles();
        Particle particles[MAX_PARTICLES];
    
    private:
        void addParticle(Particle *particle);
        void delParticle(byte index);
        byte activeParticles;
};

#endif

