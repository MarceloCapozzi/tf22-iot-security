#!/bin/bash

# enable service: openssh-server
sudo systemctl enable ssh

# start service: openssh-server
sudo systemctl start ssh

# install docker and docker-compose
wget -q -O - https://raw.githubusercontent.com/MarceloCapozzi/tf22-iot-security/main/demo/install-docker-and-docker-compose.sh | bash
