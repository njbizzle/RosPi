#/usr/bin/env python3
from __future__ import annotations
from pathlib import Path

class MockChip:
  def __init__(
      self,
      chip_path: Path
  ) -> None:
    self.chip_path: Path = chip_path
    self.lines: dict[int, MockLine] = {}


  def get_line(self, offset: int) -> MockLine:
    if not offset in self.lines:
      self.lines[offset] = MockLine(
        offset=offset
      )

    return self.lines[offset]



class MockLine:
  def __init__(
      self,
      offset: int,
  ) -> None:
    self.offset: int = offset
    self.value: int = 0

  def set_value(self, value: int) -> None:
    self.value = value

  def get_value(self) -> int:
    return self.value
