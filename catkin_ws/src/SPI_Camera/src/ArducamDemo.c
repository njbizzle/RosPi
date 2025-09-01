#include <stdlib.h>
#include <stdio.h>
#include "ArduCAM.h"
#include "sccb_bus.h"
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <pthread.h>
#include <signal.h>
#include <netdb.h>


void *readDataThread(void *arg);
//void *sendDataThread(void *arg);
void  dataParse(char* databuf);
void  INThandler(int sig);


int sockfd, newsockfd, portno, clilen;
struct sockaddr_in serv_addr, cli_addr;
struct sigaction sa;
unsigned char start_read_data = 0;
unsigned char read_data_OK = 0;

unsigned int length_cam1;
//unsigned int length_cam2;
//unsigned int length_cam3;
//unsigned int length_cam4;

extern char readbuf[JPEG_BUF_SIZE];
char revCmdData[CMD_BUF_SIZE];

int main(int argc, char *argv[])
{
  int  n;
  int on = 1;
  pthread_t _readData;//_sendData;
  pioInit();
  ArduCAM_CS_init( CAM_CS1, -1, -1, -1 );   // init the cs
  // ArduCAM_CS_init( CAM_CS1, CAM_CS2, CAM_CS3, CAM_CS4 );   // init the cs

  sccb_bus_init();
  spiInit(4000000, 0); //8MHZ

  //Arducam_bus_detect( CAM_CS1, CAM_CS2, CAM_CS3, CAM_CS4 );   // detect the SPI bus
  Arducam_bus_detect( CAM_CS1, -1, -1, -1 );

  resetFirmware( CAM_CS1, -1, -1, -1 );  //reset the firmware
  ArduCAM_Init(sensor_model);
  OV2640_set_JPEG_size(OV2640_1600x1200);
  
  singleCapture(CAM_CS1);
  FILE *f = fopen("image.jpg", "wb");
  fwrite(readbuf, 1, length, f);
  fclose(f);
  return 0;

}
