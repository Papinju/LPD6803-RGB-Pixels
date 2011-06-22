/*      Particle.cpp
 *      
 *      Floppyright 2010 Tuna <tuna@supertunaman.com>
 *      2011 michael vogt <michu@neophob.com>
 *      
 *      A particle system for the Arduino and any given graphic LCD.
 *      
 */

#include "WProgram.h"
#include "Particle.h"

#define MAX_VALUE 6
#define SCALER 5
Particles::Particles(){}
Particles::~Particles(){}

// Adds a particle to particles[]
void Particles::addParticle(Particle *particle) {
    // don't exceed the max! 
    if (activeParticles >= MAX_PARTICLES)
        return;
    
    particles[activeParticles] = *particle;
    activeParticles++;
}

// replaces particles[index] with last particle in the list
void Particles::delParticle(byte index) {
    particles[index] = particles[activeParticles - 1];
    activeParticles--;
}

// updates the posisitions of all the particles with their velocities
void Particles::moveParticles() {
    byte i;
    
    // This is what deccelerates the particles.
    for (i = 0; i < activeParticles; i++) {
        // and delete stopped particles from the list.
        if (particles[i].velX / SCALER == 0) {
            delParticle(i);
            
            // this particle is being replaced with the one at the end 
            // of the list, so we have to take a step back 
            i--; 
        }

        particles[i].x += particles[i].velX / SCALER;    // calculate true velocity
        
        if (particles[i].velX > 0) {
            particles[i].velX--;        // subtract from positive numbers
        } else {
            particles[i].velX++;        // add to negative numbers
        }
        
    }
}

// creates num_parts particles at x,y with random velocities
void Particles::createExplosion(byte x, byte num_parts) {
    byte i;
    Particle particle;
    
    for (i = 0; i < num_parts; i++)
    {
        particle.x = x;
        particle.velX = (rand() % (SCALER*MAX_VALUE));
        
        addParticle(&particle);
    }
}

byte Particles::getActiveParticles() {
    return activeParticles;
}

