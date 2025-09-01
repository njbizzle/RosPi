#include "pi_arducam/bcm283x_board_driver.h"

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <gpiod.h>


#ifdef __cplusplus
extern "C"{
#endif


struct gpiod_chip *chip = NULL;


// Pointers that will be memory mapped when pioInit() is called
volatile unsigned int *gpio; //pointer to base of gpio
volatile unsigned int *spi;  //pointer to base of spi registers
volatile unsigned int *pwm;

volatile unsigned int *sys_timer;
volatile unsigned int *arm_timer; // pointer to base of arm timer registers

volatile unsigned int *uart;
volatile unsigned int *cm_pwm;


/////////////////////////////////////////////////////////////////////
// General Functions
/////////////////////////////////////////////////////////////////////
// TODO: return error code instead of printing (mem_fd, reg_map)

int irq1, irq2, irqbasic;

void pioInit() {
	gpioInit();
}

// --- GPIO STUFF ---

// Initialize GPIO chip (call once at program start)
void gpioInit() {
    chip = gpiod_chip_open_by_name(CHIP_NAME);
    if (!chip) {
        perror("Failed to open gpiochip");
    }
}

// Release GPIO chip (call at program end)
void gpioClose() {
    if (chip) gpiod_chip_close(chip);
}

// Set pin mode
void pinMode(int pin, int function) {
    struct gpiod_line *line = gpiod_chip_get_line(chip, pin);
    if (!line) {
        perror("Failed to get line");
        return;
    }

    if (function == OUTPUT) {
        gpiod_line_request_output(line, "myprog", 0);
    } else {
        gpiod_line_request_input(line, "myprog");
    }

    gpiod_line_release(line);
}

// Digital write
void digitalWrite(int pin, int val) {
    struct gpiod_line *line = gpiod_chip_get_line(chip, pin);
    if (!line) return;

    gpiod_line_request_output(line, "myprog", 0);
    gpiod_line_set_value(line, val);
    gpiod_line_release(line);
}

// Digital read
int digitalRead(int pin) {
    struct gpiod_line *line = gpiod_chip_get_line(chip, pin);
    if (!line) return -1;

    gpiod_line_request_input(line, "myprog");
    int val = gpiod_line_get_value(line);
    gpiod_line_release(line);
    return val;
}

// Multiple pins set mode
void pinsMode(int pins[], int numPins, int fxn) {
    for (int i = 0; i < numPins; i++) {
        pinMode(pins[i], fxn);
    }
}

// Multiple pins write (val interpreted as bits)
void digitalWrites(int pins[], int numPins, int val) {
    for (int i = 0; i < numPins; i++) {
        digitalWrite(pins[i], (val >> i) & 1);
    }
}

// Multiple pins read (returns integer with bits from pins)
int digitalReads(int pins[], int numPins) {
    int result = 0;
    for (int i = 0; i < numPins; i++) {
        int bit = digitalRead(pins[i]);
        if (bit < 0) bit = 0;
        result |= (bit << i);
    }
    return result;
}


unsigned long  get_microsecond_timestamp()
{
    struct timespec t;

    if (clock_gettime(CLOCK_MONOTONIC_RAW, &t) != 0) {
        return 0;
    }

    return (unsigned long) t.tv_sec * 1000000 + t.tv_nsec / 1000;
}


void delay_us(unsigned int micros) {
	unsigned long nowtime = get_microsecond_timestamp();
	while((get_microsecond_timestamp() - nowtime)<micros/2){;}
}

void delay_ms(unsigned int millis) {
    delay_us(millis*1000);                // 1000 microseconds per millisecond
}

/////////////////////////////////////////////////////////////////////
// SPI Functions
/////////////////////////////////////////////////////////////////////

static int spi_fd = -1;

void spiInit(int freq, int settings) {
    const char *device = SPI_DEVICE_PATH;  // adjust for your SPI bus/chip
    unsigned int mode = settings & 0x03;    // example: extract mode from settings
    unsigned int bits = 8;

    spi_fd = open(device, O_RDWR);
    if (spi_fd < 0) {
        perror("spi: can't open device");
        exit(1);
    }

    if (ioctl(spi_fd, SPI_IOC_WR_MODE, &mode) < 0) {
        perror("spi: can't set mode");
        exit(1);
    }
    if (ioctl(spi_fd, SPI_IOC_WR_BITS_PER_WORD, &bits) < 0) {
        perror("spi: can't set bits per word");
        exit(1);
    }
    if (ioctl(spi_fd, SPI_IOC_WR_MAX_SPEED_HZ, &freq) < 0) {
        perror("spi: can't set max speed hz");
        exit(1);
    }
}

char spiSendReceive(char send) {
    unsigned char tx = (unsigned char)send;
    unsigned char rx = 0;

    struct spi_ioc_transfer tr = {
        .tx_buf = (unsigned long)&tx,
        .rx_buf = (unsigned long)&rx,
        .len = 1,
        .delay_usecs = 0,
        .speed_hz = 0,    // 0 = use default from init
        .bits_per_word = 8,
    };

    if (ioctl(spi_fd, SPI_IOC_MESSAGE(1), &tr) < 0) {
        perror("spi: transfer failed");
        return -1; // error case
    }

    return (char)rx;
}

short spiSendReceive16(short send) {
    unsigned short tx = (unsigned short)send;
    unsigned short rx = 0;

    struct spi_ioc_transfer tr = {
        .tx_buf = (unsigned long)&tx,
        .rx_buf = (unsigned long)&rx,
        .len = 2,
        .delay_usecs = 0,
        .speed_hz = 0,
        .bits_per_word = 16,
    };

    if (ioctl(spi_fd, SPI_IOC_MESSAGE(1), &tr) < 0) {
        perror("spi: transfer failed");
        return -1;
    }

    return (short)rx;
}


#ifdef __cplusplus
}
#endif


