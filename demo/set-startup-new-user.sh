#!/bin/bash
TOOLS=/tmp/rootfs/opt/tools
wget -q -O - https://raw.githubusercontent.com/MarceloCapozzi/tf22-iot-security/main/demo/mount-partition-to-folder.sh | bash
sudo mkdir -p $TOOLS
sudo wget -q -O $TOOLS/startup.sh https://raw.githubusercontent.com/MarceloCapozzi/tf22-iot-security/main/demo/startup.sh
sudo wget -q -O $TOOLS/new-user.sh https://raw.githubusercontent.com/MarceloCapozzi/tf22-iot-security/main/demo/new-user.sh
sudo chmod +x $TOOLS/{new-user.sh,startup.sh}
sudo su -c "echo 'bash /opt/tools/startup.sh' >> /tmp/rootfs/etc/profile"
sudo umount /tmp/{boot,rootfs}