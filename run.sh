#!/bin/sh

cd chemserv

java -Xms512M -Xmx1024M -jar ./spigot.jar nogui --forceUpgrade
