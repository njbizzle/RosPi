#include <stdlib.h>

#include <ros/ros.h>
#include <sensor_msgs/Image.h>
#include <sensor_msgs/image_encodings.h>
#include <cv_bridge/cv_bridge.h>
#include <opencv2/opencv.hpp>

#include "pi_arducam/ArduCAM.h"
#include "pi_arducam/sccb_bus.h"

#include "ros/ros.h"

int width = 320;
int height = 240;

extern char readbuf[JPEG_BUF_SIZE];

void init_arducam() {
  pioInit();
  ArduCAM_CS_init(CAM_CS1, -1, -1, -1);   // init the cs
  sccb_bus_init();
  spiInit(4000000, 0); //8MHZ
  Arducam_bus_detect(CAM_CS1, -1, -1, -1);

  resetFirmware(CAM_CS1, -1, -1, -1);  //reset the firmware
  ArduCAM_Init(sensor_model);
  // OV2640_set_JPEG_size(OV2640_1280x1024);
  OV2640_set_JPEG_size(OV2640_320x240);
}

void close_arducam() {
  // Keep adding here
  gpioClose();
}

int main(int argc, char *argv[]) {
  ros::init(argc, argv, "pi_arducam_node");
  ros::NodeHandle nh;
  ros::Publisher pub = nh.advertise<sensor_msgs::Image>("/camera/image_raw", 1);

  init_arducam();
  
  ros::Rate loop_rate(10); // 10 Hz publishing
  while (ros::ok()){
    singleCapture(CAM_CS1);

    // length is set by singleCapture
    int length = height * width * 3;
    std::vector<uchar> data(readbuf, readbuf + length);
    cv::Mat img = cv::imdecode(data, cv::IMREAD_COLOR);

    // cv::Mat bayerImg(height, width, CV_8UC1, readbuf);
    // cv::Mat rgbImg;
    // cv::cvtColor(bayerImg, rgbImg, cv::COLOR_BayerBG2RGB);

    if (!img.empty()) {
      sensor_msgs::ImagePtr msg = cv_bridge::CvImage(std_msgs::Header(), "bgr8", img).toImageMsg();
      pub.publish(msg);
    } else {
      ROS_WARN("Failed to decode frame");
    }
    ros::spinOnce();
    loop_rate.sleep();
  }

  // singleCapture(CAM_CS1);
  // FILE *f = fopen("/ros_ws/catkin_ws/image.jpg", "wb");
  // fwrite(readbuf, 1, length, f);
  // fclose(f);

  close_arducam();

  return 0;
}
