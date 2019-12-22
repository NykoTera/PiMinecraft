#!/bin/sh
chemserv='server'
chemsystem='system'
chemsave='saving'
chemdrup='DropboxUploader'
chemspigot='spigotDir'
saveserv='save'
serverserv='server'
installchoice='1'

echo 'Initializing... '

echo "Additional tools :"
echo "where do you want to download dropbox_uploader ? "
read chemdrup
echo "where do you want spigot to install its temporary files ? "
read chemspigot

if [ -d "$chemspigot" ]
then
echo  "$chemspigot directory already existing"
else
mkdir $chemspigot
fi

echo 'Downloading files...' 
git clone -b InstallTest-2 --single-branch https://github.com/NykoTera/PiMinecraft.git installRepo
git clone https://github.com/andreafabrizi/Dropbox-Uploader.git $chemdrup

echo 'Activing scripts...'
chmod 777 installRepo/run.sh
chmod 777 installRepo/updatespigot.sh
chmod 777 $chemdrup/dropbox_uploader.sh

echo 'Preparing directories... '
echo  'Where do you want to locate your server ? '
read chemserv

if [ -d "$chemserv" ]
then
echo  "$chemserv directory already existing"
else
mkdir $chemserv
fi

echo 'Where do you want to locate your saves ? '
read chemsave

if [ -d "$chemsave" ]
then
echo  "$chemsave directory already existing"
else
mkdir $chemsave
mkdir $chemsave/logsave
fi

echo "Preparing systemd files..."

# a supprimer pour la release
if [ -d "$chemsystem" ]
then
echo  "$chemsystem directory already existing"
else
mkdir $chemsystem
fi

echo 'How would you name your .service file ? '
read serverserv
echo 'How would you name your automatic saving service ? '
read saveserv

cp installRepo/save.service installRepo/$saveserv.service
cp installRepo/save.timer installRepo/$saveserv.timer
cp installRepo/server.service installRepo/$serverserv.service

echo "Generating links..."
sed -i -e "s/chemDrUp/$chemdrup/g" installRepo/updatespigot.sh
sed -i -e "s/chemSpigot/$chemspigot/g" installRepo/updatespigot.sh
sed -i -e "s/serverServ/$serverserv/g" installRepo/updatespigot.sh
sed -i -e "s/chemServ/$chemserv/g" installRepo/updatespigot.sh
sed -i -e "s/chemSave/$chemsave/g" installRepo/updatespigot.sh
sed -i -e "s/serverServ/$serverserv/g" installRepo/*.service
sed -i -e "s/chemServ/$chemserv/g" installRepo/*.service
sed -i -e "s/chemSave/$chemsave/g" installRepo/*.service
sed -i -e "s/chemServ/$chemserv/g" installRepo/run.sh

echo "Installing files..."
cp installRepo/run.sh $chemserv
cp installRepo/updatespigot.sh $chemsave
cp installRepo/$saveserv* installRepo/$serverserv* $chemsystem

echo "Removing install files..."
rm -r installRepo

echo "Setting-up server"
while [ -z "$installchoice" ]
do
clear
echo "

---------------------------------------------------/-/-/

Which kinf of files would you use ?

\t N -- \t I want to create a brand new server
\t D -- \t I want to download an existing server files (tar.gz)
\t M -- \t I want to use my own files (manual)

What's your choice ? N,D or M ? \c"
read installchoice
clear
case "$installchoice" in
[Nn]*) echo "lancer le serveur (suite)" ;;
[Dd]*) echo "Download file from url...";;
[Mm]*) echo "on ne lance pas le serveur à la fin";;
*) echo "Please, choose N,D or M";;
esac
done

echo "Initializing additional tools..."
#wget -nd  https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -O $chemspigot/BuildTools.jar
#java -Xmx1024M -jar $chemspigot/BuildTools.jar --rev 1.14.4
#cp $chemspigot/spigot-* $chemserv/spigot.jar

#$chemdrup/dropbox_uploader.sh

echo 'Done'
