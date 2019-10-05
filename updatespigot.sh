#!/bin/sh

#   Save all in a log
#exec > /chemSave/temp.log 2>&1

#   Path to dropbox_uploader
pathUpload='/home/pi/Desktop/MinecraftServer/bin'

#   Waiting proper Minecraft server ending
sleep 10

cd /chemSave
#   Saving Minecraft server in a .tar.gz archive
tar -cvzf teraminesave-$(date +%Y%m%d-%H%M).tar.gz chemServ

cd /chemSave
#   Clear Buildtools and download latest buildtools.jar
ls | grep -v updatespigot.sh | sudo xargs rm -r
sudo wget -nd  https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -O BuildTools.jar
sudo java -Xmx1024M -jar BuildTools.jar --rev 1.14.4

cd /chemServ
#   Saving the 2 latest minecraft logs and deleting former spigot.jar version
sudo tar -cvzf /chemSave/logsave-$(date +%Y%m%d-%H%M).tar.gz logs
sudo rm spigot.jar logs -r

cd /chemServ
#   Deleting older logs and copying latest spigot.jar
ls -1rt UpdateSpigotSave/logsave | head -n-2 | xargs -I TITI sudo rm UpdateSpigotSave/logsave/TITI
cp UpdateSpigotSave/temp/spigot-* chemServ/spigot.jar

#   Restart Minecraft server
sudo systemctl start serverServ.service
sleep 10

#   Conservation et upload sur la dropbox des 2 dernières sauvegardes
ls -1rt TeraMineSave | head -n-2 | xargs -I save rm chemSave/save
$pathUpload/dropbox_uploader.sh -q -d list / | awk "{print \$3}" | xargs -I TATA $pathUpload/dropbox_uploader.sh -d delete TATA
ls -1rt TeraMineSave | xargs -I TUTU $pathUpload/dropbox_uploader.sh -d upload TeraMineSave/TUTU TUTU

cd
