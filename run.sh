#!/bin/sh

cd chemserv

java -Xms512M -Xmx1024M -XX:+UseConcMarkSweepGC -jar ./spigot.jar nogui --forceUpgrade
