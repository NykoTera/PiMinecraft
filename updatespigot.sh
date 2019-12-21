#!/bin/sh

#   Save all in a log
#exec > chemSave/process.log 2>&1

#   Path to dropbox_uploader
pathUpload='chemDrUp'

#   Waiting proper Minecraft server ending
sleep 10

#   Saving Minecraft server in a .tar.gz archive
tar -cvzf chemSave/teraminesave-$(date +%Y%m%d-%H%M).tar.gz chemServ

#   Clear Buildtools and download latest buildtools.jar
shopt -s dotglob
rm -rf chemSpigot/*
sudo wget -nd  https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -O chemSpigot/BuildTools.jar
sudo java -Xmx1024M -jar chemSpigot/BuildTools.jar --rev 1.14.4

#   Saving the 2 latest minecraft logs and deleting former spigot.jar version
sudo tar -cvzf chemSave/logsave/logsave-$(date +%Y%m%d-%H%M).tar.gz chemServ/logs
sudo rm chemServ/spigot.jar chemServ/logs -r

#   Deleting older logs and copying latest spigot.jar
find chemSave/logsave -type f -exec basename {} \; | sort -r | head -n-2 | xargs -I TITI sudo rm chemSave/logsave/TITI
cp chemSpigot/spigot-* chemServ/spigot.jar

#   Restart Minecraft server
sudo systemctl start serverServ.service
sleep 10

#   Conservation et upload sur la dropbox des 2 dernières sauvegardes
find chemSave -type f -name '*tar*' -exec basename {} \; | sort -r | head -n-2 | xargs -I TOTO sudo rm chemSave/TOTO
$pathUpload/dropbox_uploader.sh -q -d list / | awk "{print \$3}" | xargs -I TATA $pathUpload/dropbox_uploader.sh -d delete TATA
find chemSave -type f -name '*tar*' -exec basename {} \; | sort | xargs -I TUTU $pathUpload/dropbox_uploader.sh -d upload chemSave/TUTU TUTU
