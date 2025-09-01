#!/usr/bin/env python3

import gpiod, rospy
from std_msgs.msg import Bool, UInt16
from pi_gpio import get_config, get_chip

class GPIOSetter:
  def __init__(
    self,
    chip_path: str
  ):
    try:
      self.chip: gpiod.chip = gpiod.chip(chip_path)
    except TypeError:
      rospy.logerr("Can't open GPIO chip. Is the path correct and does the device have GPIO headers?")
      return
    self.lines: dict[int, gpiod.line] = {}

    rospy.Subscribe("/gpio/request_line", UInt16, callback=request_line)


  def set_callback(self, val: Bool, offset: int):
    self.lines[val].set_value(val.data)


  def request_line(self, offset: int):
    if offset in self.lines:
      rospy.logwarn("Asked to request line already owned by GPIO Setter.")
      return
    
    line: gpiod.line = self.chip.get_line(offset)

    if line.is_requested():
      rospy.loginfo(f"Requesting transfer of ownership of line {offset} from {line.consumer}.")
    else:
      rospy.loginfo(f"Requesting ownership of line {offset}.")

    request: gpiod.line_request = gpiod.line_request()
    request.request_type = gpiod.line_request.DIRECTION_OUTPUT
    request.consumer = "pi_gpio_setter"

    line.request(request, default_val=1)

    rospy.Subscriber("/gpio/line{offset}/set", Bool, callback=lambda val: self.set_callback(val, offset))


def main() -> None:
  rospy.init_node("pi_gpio_setter")
  setter: GPIOSetter = GPIOSetter(get_config()["chip_path"])
  
if __name__ == "__main__":
  main()
