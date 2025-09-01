#!/usr/bin/env python3
from .mock_chip import MockChip
from pathlib import Path
import rospy, yaml

CONFIG_PATH: Path = Path(__file__).parent.absolute() / "config" / "config.yaml"
mock_chip: MockChip = None
config: dict = {}

def load_config_mock_gpiod(config_name: str) -> dict:
  global config
  if not config:
    with open(CONFIG_PATH, "r") as config_file:
      config = yaml.safe_load(config_file)

  try:
    return config["mock_gpiod"][config_name]
  except KeyError as e:
    pass

  rospy.logerr("Can't open config.")
  return {}

def get_chip() -> MockChip:
  global mock_chip
  if mock_chip:
    return mock_chip
  
  mock_chip = MockChip("mock_path")

print("--- DON'T USE --- This still needs to be finished.")
