from distutils.core import setup
from catkin_pkg.python_setup import generate_distutils_setup

d = generate_distutils_setup(
  packages=['pi_gpio'], # Replace with your package name
  package_dir={'': 'src'}
)

setup(**d)
