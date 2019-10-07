#!/bin/sh
cd teramineserver /home/pi/Desktop/MinecraftServer/TeraMineServer
java -Xms512M -Xmx1024M -XX:+UseConcMarkSweepGC -jar ./spigot.jar nogui --forceUpgrade
