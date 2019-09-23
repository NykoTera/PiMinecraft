# PiMinecraftAuto

**The easy way to setup and run a safe minecraft server on raspberry pi**

This project is made for people that want to easily have a running server at home

*Note that you'll need a raspberry pi runing las raspbian operating system*
*If you don't have much memory (if you have less than 1Gb memory), you can disable gui mode.*
*Note that a 16Gb is a minimum size for the memory card*

---

## Prerequisite

1. You'll need to ensure you're running the [latest raspbian version](https://www.raspberrypi.org/documentation/raspbian/updating.md)
2. You'll need the [latest java version](https://tecadmin.net/install-oracle-java-11-on-debian-9-stretch/)
3. [Download the latest buildtools.jar to generate a spigot.jar file](https://www.spigotmc.org/wiki/buildtools/)

---

## Minecraft server

**Before thinking to save a server, you'll have to setup your server**

There are [lot of tutorial](https://www.makeuseof.com/tag/setup-minecraft-server-raspberry-pi/) on the internet on how to easily setup this kind on server.
I'll only leave you the "run.sh" script. See the previous link for installation

**For the latest spigot version, [please see Spigot wiki](https://www.spigotmc.org/wiki/buildtools/#latest). Remember that the saving script can help you.**
**[You can fin more help for configuration and parameters on spigot wiki](https://www.spigotmc.org/wiki/spigot/)**

Remember that the first launch will build all the data needed by the server (map,...).

*My advice : Put your server in a dedicated folder*

---

## Systemd

First, [you'll need to know what is systemd](https://wiki.debian.org/systemd).
It will help us in many things :

1. Run server when raspberry start
2. Run automatic saves
3. Stop the server when shuting down the raspberry

*NB : all the systemd files will be put in the* '/etc/systemd/system' *directory*

Here are the 3 files :

1. server.service : That's the service that launch your server when raspberry starts and that manage to properly stop the server when needed
2. save.service : That's the service that will stop the server and launch the save script
3. save.timer : that's the service that will automaticaly launch save.service (replace cronjob)

**It's important that the timer file have the same name as the service it will launch**

*You can rename all the files as you wish, but the directory can only be /etc/systemd/system*

You can modify *run.sh* file if you're using a raspberry pi 4. If you do that, you can allow the server to use more memory.

---

## The core script

It's the script that's launched when the save.service is activated.
Its first goal is to copy you're server folder as an archive.

Note that I haded some optional improvements to simplify my use of the server. All this improvements are optional :

**1. Saving logs**

It could be usefull to save the server logs so I added a script line that save the two latest logs into a specific folder.

**2. Uploading the latest saves on dropbox and keep the only 2 latest saves**

For the save to be complete, I thought it could be interesting to have a server save on the internet. If the raspberry burn, you can still use the latest save !
This functionality use the [dropbox_uploader](https://github.com/andreafabrizi/Dropbox-Uploader) script by @andrefabrizi.

**3. Automatic server update**

Spigot offers the opportunity to build your spigot version. Using the buildtools tool, you can get the latest version.
This functionality use the [buildtools](https://hub.spigotmc.org/jenkins/job/BuildTools/) script by spigot.

---

## Future developments

Actually, you'll have to download all the files and put it in th right folder manually. My goal is to develop a script that will download "install" this tools automatically. It will ask you the name of the different files, the folder directory,...
