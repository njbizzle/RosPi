from distutils.core import setup
from catkin_pkg.python_setup import generate_distutils_setup

d = generate_distutils_setup(
  packages=['mock_gpiod'], # Replace with your package name
  package_dir={'': 'src'}
)

setup(**d)
