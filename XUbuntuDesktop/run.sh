#!/bin/bash
docker run -v/home/ubuntu/:/home/ubuntu -v/var/run/docker.sock:/var/run/docker.sock  -p8590:8590 -it xubuntudesktop
