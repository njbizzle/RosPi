
#ifndef BCM_283X_H
#define BCM_283X_H

#include <sys/mman.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <string.h>
#include <sys/ioctl.h>
#include <linux/spi/spidev.h>

#ifdef __cplusplus
extern "C"{
#endif

/////////////////////////////////////////////////////////////////////
// Constants
/////////////////////////////////////////////////////////////////////

// GPIO FSEL Types
#define INPUT  0
#define OUTPUT 1
#define ALT0   4
#define ALT1   5
#define ALT2   6
#define ALT3   7
#define ALT4   3
#define ALT5   2

#define CHIP_NAME "gpiochip0"
#define SPI_DEVICE_PATH "/dev/spidev0.0"

// Pin function
#define INPUT  0
#define OUTPUT 1

// Clock Manager Bitfield offsets:
#define PWM_CLK_PASSWORD 0x5a000000
#define PWM_MASH 9
#define PWM_KILL 5
#define PWM_ENAB 4
#define PWM_SRC 0

// PWM Constants
#define PLL_FREQUENCY 500000000 // default PLLD value is 500 [MHz]
#define CM_FREQUENCY 25000000   // max pwm clk is 25 [MHz]
#define PLL_CLOCK_DIVISOR (PLL_FREQUENCY / CM_FREQUENCY)

/////////////////////////////////////////////////////////////////////
// Interrupt Functions
/////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////
// GPIO Functions
/////////////////////////////////////////////////////////////////////
#define HIGH  1
#define LOW   0

extern void pioInit();

// extern void noInterrupts(void);
// extern void interrupts(void);


extern void gpioInit();
extern void gpioClose();
extern void pinMode(int pin, int function);
extern void digitalWrite(int pin, int val);

extern int digitalRead(int pin);
extern void pinsMode(int pins[], int numPins, int fxn);
extern void digitalWrites(int pins[], int numPins, int val);
extern int digitalReads(int pins[], int numPins);
extern void delay_us(unsigned int micros);
extern void delay_ms(unsigned int millis);

/////////////////////////////////////////////////////////////////////
// SPI Functions
/////////////////////////////////////////////////////////////////////

extern void spiInit(int freq, int settings);
extern char spiSendReceive(char send);
extern short spiSendReceive16(short send) ;

#ifdef __cplusplus
}
#endif

#endif
