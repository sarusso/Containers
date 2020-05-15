#!/bin/bash
set -e

# This system dependencies installer is meant to be executed
# on top of a clean and official Ubuntu 18.04 Docker image.
# It should be also capable of running twice without messing up.

# Curl
apt-get install curl -y

# Install get-pip script
curl -O https://bootstrap.pypa.io/get-pip.py

# Install Python and pip in this order (first Python 3 and then Python 2), or 
# you will end ap with python defaulting to python2 and pip defaulting to pip3
# Otherwise, do somethign like "ln -s /usr/local/bin/pip3 /usr/local/bin/pip"

# Install Python3 and Pip3 (python3-distutils required for pip3)
apt-get install python3 python3-distutils -y 
python3 get-pip.py 'pip==10.0.1'

# Install Python2 and Pip2
apt-get install python -y
python get-pip.py 'pip==10.0.1'

# Python-tk required by matplotlib/six
apt-get install python-tk python3-tk -y

# Required for building subprocess32 in Python 2, required by matplotlib
# (subprocess32 is a backport for Python 2 of Python 3 subprocess module)
apt-get install build-essential python-dev -y

# Install ffmpeg (consider replacing with a more dependency-lightweight one)
apt-get install ffmpeg -y

# Required to fix bug with Theano (lazylinker)
apt-get install python3.6-dev -y
