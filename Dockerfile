FROM nvidia/cuda:11.2.0-base-ubuntu20.04
MAINTAINER ikeyasu <ikeyasu@gmail.com>

ENV DEBIAN_FRONTEND oninteractive

############################################
# Basic dependencies
############################################
RUN apt-get update --fix-missing && apt-get install -y \
      python3-pip \
      cmake \
      git \
      libopencv-dev opencv-data \
    && apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python

############################################
# Change the working directory
############################################
WORKDIR /opt

############################################
# OpenAI Gym and pfrl 
############################################
RUN pip3 install --upgrade pip
RUN pip3 install 'gym[atari]' 'gym[box2d]' 'gym[classic_control]' pfrl six

# Test pfrl
RUN cd /opt \
    && curl https://raw.githubusercontent.com/pfnet/pfrl/master/examples/atari/reproduction/dqn/train_dqn.py > train_dqn.py \
    && python3 train_dqn.py --env PongNoFrameskip-v4 --steps 100 --replay-start-size 50 --outdir /opt/dqn-result --eval-n-steps 200 --eval-interval 50 --n-best-episodes 1 --gpu -1 \
    && rm -rf /opt/dqn-result
