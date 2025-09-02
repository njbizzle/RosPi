ARG ROS_BASE=ros:noetic-ros-core
FROM ${ROS_BASE}

# ???
ENV DEBIAN_FRONTEND=noninteractive

ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
  && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && mkdir /home/$USERNAME/.config && chown $USER_UID:$USER_GID /home/$USERNAME/.config \
  && adduser $USERNAME sudo \
  && sudo passwd -d $USERNAME

# Create gpio and spi groups
RUN groupadd -f gpio && groupadd -f spi \
    && usermod -aG gpio,spi $USERNAME

# # Set up udev rules so gpio/spi devices are accessible to these groups
# RUN echo 'KERNEL=="gpiochip*", GROUP="gpio", MODE="0660"' > /etc/udev/rules.d/99-gpio.rules \
#     && echo 'KERNEL=="spidev*", GROUP="spi", MODE="0660"' > /etc/udev/rules.d/99-spi.rules

USER root

# Update packages
RUN apt-get update && apt-get install -y \
  iputils-ping \
  git \
  wget \
  gpiod \
  libgpiod-dev \
  libepoxy-dev \
  curl ca-certificates \
# We have to be using python3, python might point to 2.x.
  python3-pip \
# Really need this.
  python-is-python3 \
# We have to apt-get install this because the library
# wraps a whole lot c libraries, which need to be installed
# through a package manager like apt-get, this just does all that.
# python3-libgpiod \
  ros-noetic-camera-calibration \
  ros-noetic-image-pipeline \
  ros-noetic-rviz \
  ros-noetic-rqt-graph \
  ros-noetic-rqt-image-view \
  ros-noetic-rospy-tutorials \
  ros-noetic-turtlesim \
# Scary amount of data, refrain from this.
  # ros-noetic-desktop-full\ 
# Small optimization to clear cached data from apt-get.
# Saves a few 10s of megabytes.
  && rm -rf /var/lib/apt/lists/*


# Crazy amount of dependancies to run graphical stuff.
RUN apt-get update && apt-get install -y \
  x11-apps \
  mesa-utils \
  qt5-default \
  libx11-6 \
  libx11-xcb1 \
  libxext6 \
  libxrender1 \
  libsm6 \
  libice6 \
  libxtst6 \
  libxi6 \
  libxcb1 \
  libxcb-util1 \
  libxcb-icccm4 \
  libxcb-image0 \
  libxcb-keysyms1 \
  libxcb-randr0 \
  libxcb-render-util0 \
  libxcb-shape0 \
  libxcb-shm0 \
  libxcb-sync1 \
  libxcb-xfixes0 \
  libxcb-xinerama0 \
  libxcb-xkb1 \
  libxkbcommon0 \
  libxkbcommon-x11-0 \
  libgl1-mesa-glx \
  libgl1-mesa-dri \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /ros_ws
COPY requirements.txt /ros_ws

RUN wget -O /tmp/code.deb https://update.code.visualstudio.com/1.103.2/linux-deb-arm64/stable \
 && apt-get update \
 && apt-get install -y /tmp/code.deb
#  && rm /tmp/code.deb

RUN pip install --upgrade pip  \
  && pip install --no-cache-dir -r /ros_ws/requirements.txt
# && pip install ArducamSDK
# ^ Is explicitly installing arducam needed? (pip doesn't like it on the mac)

COPY /catkin_ws /ros_ws/catkin_ws

RUN apt-get install python3-rosdep \
  && rosdep init \
  && rosdep update

WORKDIR /ros_ws/catkin_ws/
RUN git clone https://github.com/RAFALAMAO/ORB_SLAM3_NOETIC/
WORKDIR /ros_ws/catkin_ws/ORB_SLAM3_NOETIC/Thirdparty
RUN git clone https://github.com/stevenlovegrove/Pangolin.git
WORKDIR /ros_ws/catkin_ws/ORB_SLAM3_NOETIC/Thirdparty/Pangolin
RUN mkdir build && cd build && \
  cmake .. -DCMAKE_CXX_FLAGS="-Wno-error -Wno-type-limits -Wno-deprecated-copy" && \
  make && make install

WORKDIR /ros_ws/catkin_ws/ORB_SLAM3_NOETIC

# Run make instead of make -j
RUN sed -i 's/make -j/make/g' build.sh && \
  sed -i 's/make -j/make/g' build_ros.sh

# Update CMakeLists to use CPP 17
RUN rm CMakeLists.txt
RUN rm Examples/ROS/ORB_SLAM3/CMakeLists.txt
COPY orbslam_cmakelists/orbslam.txt CMakeLists.txt
COPY orbslam_cmakelists/orbslam_ros.txt Examples/ROS/ORB_SLAM3/CMakeLists.txt

# Export env 
# ENV ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:/ros_ws/catkin_ws/ORB_SLAM3_NOETIC/Examples/ROS
# ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# From ORB_SLAM3 root
RUN find Examples -type f -print0 | xargs -0 sed -i 's/monotonic/steady/g'
RUN find src -type f -print0 | xargs -0 sed -i 's/mnFullBAIdx++;/mnFullBAIdx = true;/g'

RUN chmod +x build.sh build_ros.sh
RUN ./build.sh


RUN echo "testingtesting"
RUN echo $ROS_PACKAGE_PATH
RUN ls /opt/ros/noetic

COPY scripts/remote_start/entrypoint.bash /entrypoint.bash
COPY scripts/remote_start/bashrc /home/${USERNAME}/.bashrc
COPY vscode_server_deps/.config /home/${USERNAME}/.config
COPY vscode_server_deps/.dotnet /home/${USERNAME}/.dotnet
COPY vscode_server_deps/.local /home/${USERNAME}/.local
COPY vscode_server_deps/.vscode-server /home/${USERNAME}/.vscode-server

RUN chown -R $USER_UID:$USER_GID /ros_ws
RUN chown -R $USER_UID:$USER_GID /home/${USERNAME}

# Specifying the full path helps bash run consistenly.
# It then exports the bash enviroment variable so we 
# can just call bash now.

ENTRYPOINT ["/bin/bash", "/entrypoint.bash"]
CMD ["bash"]
