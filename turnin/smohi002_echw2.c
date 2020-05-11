/*	Author: sana
 *  Partner(s) Name: 
 *	Lab Section:
 *	Assignment: Lab #  Exercise #
 *	Exercise Description: [optional - include for your own benefit]
 *
 *	I acknowledge all content contained herein, excluding template or example
 *	code, is my own original work.
 */
#include <avr/io.h>
#ifdef _SIMULATE_
#include "simAVRHeader.h"
#include "../header/timer.h"
#endif

enum States {start, off, on, cw, ccw, wait, forward, hit} state;

unsigned char A = 0x00;
unsigned char B = 0x00;
unsigned char i = 0x00;
unsigned char hits = 0x00;

void Tick() {
	switch(state) {
		case start: 
			state = off;
			PORTB = 0x00;
		      	break;
		case off:
		      if (!A) state = off;
		      else {state = on; i = 0;}
		      break;
		case on:
		      if (!A) {state = off; B = 0x00;}
		      else state = cw;
		      break;
		case cw:
		      if ((A & 0x01) == 0x00) state = off;
//		      else if (i <= 4 && hits < 3) state = ccw;
		      else if (i > 4 && hits < 3) { state = wait; i = 0;}
		      else if (hits >= 3) {state = hit; i = 0;}
		      else state = ccw;
		      break;
		case ccw:
			if ((A & 0x01) == 0x00) state = off;
//			else if (i <= 4 && hits < 3) {state = cw;}
//			else if (hits >= 3) {state = hit; i = 0;}
			else if (i > 4 && hits < 3) { state = wait; i = 0;}
			else if (hits >= 3) {state = hit; i = 0;}
			else state = cw;
		      break;
		case wait:
			if((A & 0x01) == 0x00) state = off;
//			else if (hits >= 3) {state = hit; i = 0;}
			else if (i <= 2 && hits < 3) state = wait;
			else /*if (i > 2 && hits < 3)*/ {state = forward; i = 0;}
		      break;
		case forward:
		      	if ((A & 0x01) == 0x00) state = off;
			else if (i <= 4) state = forward;
			else {state = cw; i = 0;}
			break;
		case hit:
			if ((A & 0x01) == 0x00) state = off;
			else if (i <= 4) state = hit;
			else {state = cw; i = 0;}
		      break;
		default:
		      state = start;
		      break;
	}
	switch(state) {
		case start: break;
		case off:   break;
		case on: 
			B = 0x01;
			break;
		case cw: 
			i++;
			B = 0x03;
			if (A == 0x03) hits++;
			break;
		case ccw: 
			i++;
			B = 0x07;
			if (A == 0x03) hits++;
			break;
		case wait: 
			B = 0x01;
			i++;
			if (A == 0x03) hits++;
			break;
		case forward:
			B = 0x03;
			i++;
			break;
		case hit: 
			i++;
			hits = 0x00;
			B = 0x01;
			break;
		default: break;
	}
}

int main(void) {
	DDRA = 0x00; PORTA = 0xFF;
	DDRB = 0xFF; PORTB = 0x00;

	B = 0x00;
	i = 0x00;
	hits = 0x00;

	state = start;
	TimerSet(500);
	TimerOn();

	while (1) {
		A = ~PINA & 0x03;
	    Tick();
	    while (!TimerFlag);
	    TimerFlag = 0;
	    PORTB = B;
	}
    return 1;
}
