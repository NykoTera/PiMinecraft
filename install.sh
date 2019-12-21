#!/bin/sh
chemServ='system'
chemSystem='system'
chemSave='saving'
saveServ='save'
serverServ='server'

echo 'Downloading files' 
git clone https://github.com/NykoTera/PiMinecraft.git installRepo

echo 'Activing scripts'
chmod 777 run.sh
chmod 777 updatespigot.sh

echo 'Moving important files to their directory'
echo 'Where do you want to locate your server ?'
read chemServ

if [ -d $chemServ ]
then
cp installRepo/run.sh $chemServ
else
mkdir $chemServ
cp installRepo/run.sh $chemServ
fi

echo 'Where do you want to locate your save ?'
read chemSave

if [ -d $chemSave ]
then
cp installRepo/updatespigot.sh $chemSave
else
mkdir $chemSave
cp installRepo/updatespigot.sh $chemSave
fi

echo 'Moving systemd files to /etc/systemd/system'
echo 'How would you name your .service file ?'
read serverServ
echo 'How would you name your automatic saving service ?'
read saveServ

if [ -d $chemSystem ]
then
cp installRepo/server* installRepo/$serverServ* $chemSystem
else
mkdir $chemSystem
cp installRepo/save* installRepo/$serverServ* $chemSystem
fi

echo 'Done'
