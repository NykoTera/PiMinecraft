#!/bin/sh

#   Save all in a log
#exec > chemsave/process.log 2>&1

#   Path to dropbox_uploader
pathUpload='chemdrup'

#   Waiting proper Minecraft server ending
sleep 10

#   Saving Minecraft server in a .tar.gz archive
tar -cvzf chemsave/Save-$(date +%Y%m%d-%H%M).tar.gz chemserv

#   Clear Buildtools and download latest buildtools.jar
shopt -s dotglob
rm -rf chemspigot/*
sudo wget -nd  https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -O chemspigot/BuildTools.jar
cd chemspigot
sudo java -Xmx1024M -jar chemspigot/BuildTools.jar --rev 1.20.1
cd

#   Saving the 2 latest minecraft logs and deleting former spigot.jar version
sudo tar -cvzf chemsave/logsave/logsave-$(date +%Y%m%d-%H%M).tar.gz chemserv/logs
sudo rm chemserv/spigot.jar chemserv/logs -r

#   Deleting older logs and copying latest spigot.jar
find chemsave/logsave -type f -exec basename {} \; | sort -r | head -n-2 | xargs -I TITI sudo rm chemsave/logsave/TITI
cp chemspigot/spigot-* chemserv/spigot.jar

#   Restart Minecraft server
sudo systemctl start serverserv.service
sleep 10

#   Conservation et upload sur la dropbox des 2 dernières sauvegardes
find chemsave -type f -name '*tar*' -exec basename {} \; | sort -r | head -n-2 | xargs -I TOTO sudo rm chemsave/TOTO
$pathUpload/dropbox_uploader.sh -q -d list / | awk "{print \$3}" | xargs -I TATA $pathUpload/dropbox_uploader.sh -d delete TATA
find chemsave -type f -name '*tar*' -exec basename {} \; | sort | xargs -I TUTU $pathUpload/dropbox_uploader.sh -d upload chemsave/TUTU TUTU
