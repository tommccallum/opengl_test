FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -y upgrade
RUN apt-get -y update
#RUN apt-get -y install apt-utils 
RUN apt-get -y install build-essential g++ clang pkg-config
RUN apt-get -y install zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev 
RUN apt-get -y install libreadline-dev libffi-dev wget
RUN apt-get -y install vim cmake valgrind
RUN apt-get -y install ccache 
RUN apt-get -y install python3.8 python3-pip
RUN pip3 install cmake_format
RUN apt-get -y install cppcheck
RUN pip3 install conan
RUN apt-get -y install doxygen graphviz
RUN apt-get -y install libgl1-mesa-dev libglu1-mesa-dev zlib1g-dev
RUN apt-get -y install libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev
RUN apt-get -y install git 
RUN apt-get -y install libirrlicht-dev
RUN apt-get -y install glmark2
# RUN apt-get -y install libglvnd0 \
#     libgl1 \
#     libglx0 \
#     libegl1 \
#     libxext6 \
#     libx11-6
# RUN apt-get install -qqy x11-apps

# # Env vars for the nvidia-container-runtime.
# ENV NVIDIA_VISIBLE_DEVICES all
# ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute

RUN rm -rf /app/build || true
COPY . /app
WORKDIR /app
RUN chmod +x build.sh
RUN ./build.sh clean
RUN ./build.sh
