# PiMinecraftAuto

**Voici la méthode facile (et automatique) de configurer et faire fonctionner un serveur minecraft sur raspberry pi**

Ce projet est fait pour ceux qui veulent facilement disposer d'un serveur à domicile

*Veuillez noter que vous aurez besoin d'un raspberry fonctionnant sous une version à jour de raspbian*
*Si vous avez peu de mémoire vive (environ 1Gb ou moins), vous pouvez désactiver l'interface graphique de raspbian.*
*Je recommande une carte SD d'au moins 16Gb*



## Prérequis

1. Vous devez vous assurer de disposer de la  [dernière version de raspbian](https://www.raspberrypi.org/documentation/raspbian/updating.md)
2. Vous aurez besoin de la [dernière version de java](https://tecadmin.net/install-oracle-java-11-on-debian-9-stretch/)
3. [Téléchargez le dernier buildtools.jar pour générer un fichier spigot.jar](https://www.spigotmc.org/wiki/buildtools/)



## Serveur Minecraft

**Avant de penser à sauvegarder les données de votre serveur, il faut le configurer**

Il existe [de nombreux tutoriels](https://www.makeuseof.com/tag/setup-minecraft-server-raspberry-pi/) sur internet qui expliquent simplement comment installer ce genre de serveur.
Je vous laisse simplement le script `run.sh`. Reportez-vous aux liens ci-dessus pour l'installation

**Pour télécharger la dernière version de Spigot, [reportez-vous au wiki Spigot](https://www.spigotmc.org/wiki/buildtools/#latest). Pour mémoire, le script de sauvegarde peut aussi gérer les mises à jour de Spigot.**
**[Vous trouverez des informations complémentaires concernant l'installation et le paramétrage sur le wiki spigot](https://www.spigotmc.org/wiki/spigot/)**

Souvenez-vous que le premier lancement du script va créer les données nécessaires au serveur (cartes,...).

*Mon conseil : rangez votre serveur dans un dossier dédié et expmicitement nommé (ex : MonServeur).*



## Systemd

Dans un premier temps, [vous devez savoir ce qu'est systemd](https://wiki.debian.org/systemd).
Cela vous aidera notamment pour :

1. Lancer le serveur au démarrage du raspberry
2. Exécuter les sauvegardes automatiques
3. Eteindre proprement le serveur à l'arrêt du raspberry

*NB : Tous les fichiers liés à systemd devront être placées dans le dossier * `/etc/systemd/system`

Les 3 fichiers concernés sont :

1. `server.service` : C'est le service qui lance le serveur au démarrage du raspberry et qui gère son arrêt propre lorsque nécessaire
2. `save.service` : C'est le service qui arrête le serveur et lance le script de sauvegarde
3. `save.timer` : C'est le timer qui lance automatiquement save.service (ce service remplace cronjob)

**Il est important que le fichier `.timer` porte le même nom que le fichier `.service` pour que le service fonctionne**

*Vous pouvez renommer tous les fichiers à votre convenance, mais ils seront impérativement placés dans le dossier* `/etc/systemd/system`

Si vous utilisez un raspberry pi 4, vous pouvez modifier le fichiet `run.sh`. Cela vous permettra notamment d'allouer plus de mémoire au serveur.



## Le script central

C'est le script initialisé quand le service `save.service` se lance.
Son premier objectif est de créer une archive du dossier de votre serveur.

Notez que j'ai ajouté des options pour simplifier mon usage du serveur. Tout cececi est optionnel :

**1. Sauvegarde des logs**

Il peut être utile de sauvegarder les logs, c'est pourquoi j'ai ajouté une ligne de script qui sauvegarde les deux derniers logs dans un dossier spécifique.

**2. Uploader les dernières sauvegardes sur dropbox et ne garder que les 2 derniers fichiers**

Pour plus de sûreté, j'ai pensé qu'il pouvais être utile d'avoir une sauvegarde sur internet. Dzns ce cas, même si le raspberry brûle, vous pouvez toujours utiliser une sauvegarde !
Cette fonction utilise le script [dropbox_uploader](https://github.com/andreafabrizi/Dropbox-Uploader) développé par [@andreafabrizi](https://github.com/andreafabrizi).

**Souvenez-vous que tous les scripts sont lancés en tant que root, donc le paramétrage de dropbox_uploader doit être fait en tant que root. Une simple commande `sudo dropbox_uploader.sh` fera l'affaire.**

**3. Mise à jour automatique du serveur**

Spigot offre la possibilité de compiler une version spigot sur mesure. En utilisant l'outil `buildtools.jar`, vous pouvez avoir la dernière version.
Cette fonctionalité nécessite l'usage du script [buildtools](https://hub.spigotmc.org/jenkins/job/BuildTools/) mis à disposition par spigot.



## Comment mettre en place la sauvegarde automatique

Il vpus faudra ouvrir un terminal et copier cette commande :
`wget https://raw.githubusercontent.com/NykoTera/PiMinecraft/InstallTest/install.sh && bash install.sh`

Le script vous demandera :
1. Où vous voulez locamiser votre serveur (en utilisant un chemin relatif ou absolu)
2. Où se situerons vos sauvegardes
3. Comment s'appellera le fichier systemd (`.service`)
4. Comment s'appelleront les fichiers de sauvegarde (`.service` et `.timer`)



## A venir (en réflexion du moins...)

Pour le moment vous pouvez seulement créer un nouveau serveur, mais je vais le modifier pour vous permettre de réutiliser vos propres serveurs, quitte à les télécharger.
