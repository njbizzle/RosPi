#!/usr/bin/env python3

import gpiod, rospy, yaml
from pathlib import Path

from pi_gpio.msg import LineState

CONFIG_PATH: Path = Path(__file__).parent.absolute() / "config" / "config.yaml"

def get_chip(config: dict) -> gpiod.chip:
  chip: gpiod.chip = gpiod.chip.open(config["chip_path"], gpiod.Chip.OPEN_BY_PATH)
  return chip

def get_config() -> dict:
  with open(CONFIG_PATH, "r") as config_file:
    config = yaml.safe_load(config_file)

  try:
    return config["pi_gpio"]
  except KeyError as e:
    rospy.logerr("Failed to load pi_gpio config.")
    return {}
  
