#!/usr/bin/env python3
import rospy

from mock_gpiod import MockChip, MockLine, get_chip
from pi_gpio.msg import SetLineValue
from pi_gpio.srv import GetLineValue


def gpio_state_callback() -> None:
  pass

def main() -> None:
  rospy.init_node("pi_gpio_node")
  rate: rospy.Rate = rospy.Rate(2)

  while not rospy.is_shutdown():
    rate.sleep()
  

if __name__ == "__main__":
  main()
