# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    setup.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: kaye <kaye@student.42.fr>                  +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/04/05 09:58:40 by kaye              #+#    #+#              #
#    Updated: 2021/04/12 22:50:45 by kaye             ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

## ANSI COLOR CODES

BLACK="\033[1;30m"
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
PURPLE="\033[1;35m"
CYAN="\033[1;36m"
NONE="\033[0m"
CLR_SCREEN="\033[2J\033[H"$CYAN""

# generate by the command "figlet"
echo "$CLR_SCREEN$CYAN\
 _____ _                           _
|  ___| |_     ___  ___ _ ____   _(_) ___ ___  ___
| |_  | __|   / __|/ _ \ '__\ \ / / |/ __/ _ \/ __|
|  _| | |_    \__ \  __/ |   \ V /| | (_|  __/\__ \\
|_|    \__|___|___/\___|_|    \_/ |_|\___\___||___/
         |_____|
$NONE"

## INSTALLATION OF MINIKUBE & KUBERNETES & DOCKER - FUNCTION

function minikube_linux()
{
	echo ""$CYAN"🐧 OS : Linux\n"$NONE""

	## CONFIG FOR LINUX
	echo ""$RED"\n(If you are in the VM, please check if you are running with 2 cores)\n"$NONE""
	cat /etc/group | grep "docker" | grep $(whoami) 2>/dev/null 1>&2
	# -ne : !=
	if [ $? -ne 0 ] ; then
		# run docker without sudo
		echo ""$RED"❗️Please do"$NONE" "$YELLOW"\"sudo usermod -aG docker $(whoami); newgrp docker\""$NONE" and "$RED"rerun"$NONE" the script"
		exit
	fi

	# make sure docker is running
	service docker restart
}

function minikube_macos()
{
	echo ""$CYAN"🍎 Os : Macos\n"$NONE""

	# installation of brew
	if ! which brew 2>/dev/null 1>&2 ; then
		echo ""$GREEN"\n🍺 brew installing ..."$NONE""
		rm -rf $HOME/.brew && git clone --depth=1 https://github.com/Homebrew/brew $HOME/.brew && echo 'export PATH=$HOME/.brew/bin:$PATH' >> $HOME/.zshrc && source $HOME/.zshrc && brew update
	fi

	# installation of minikube (kubernetes-cli will installed during installation of minikube)
	if ! which minikube 2>/dev/null 1>&2 ; then
		echo ""$GREEN"\n🛳  minikube installing ..."$NONE""
		brew install minikube
	fi

	# check if /goinfre folder exist (at 42)
	if [ -d /goinfre ] ; then

		# configuration in 42
		echo ""$GREEN"\n🐳 docker running ..."$NONE""
		rm -rf /goinfre/$USER/docker
		./srcs/init_docker.sh
	
		# link minikube folder to goinfre
		if [ $MINIKUBE_HOME ] ; then

			# clean old minikube
			if [ "$MINIKUBE_HOME" = "/goinfre/$USER" ] ; then
				echo ""$CYAN"\n♻️  clean old minikube if exist ..."$NONE""
				minikube delete
			fi
		else
	
			# clean old minikube & minikube folder & relink to /goinfre/$USER
			echo ""$CYAN"\n♻️  clean old minikube if exist ..."$NONE""
			minikube delete
			rm -rf $HOME/.kube
			rm -rf $HOME/.minikube
			if ! grep MINIKUBE_HOME 2>/dev/null 1>&2 ; then
				echo ""$GREEN"\n↔️  link minikube folder to /goinfre/\$USER ..."$NONE""
				echo "export MINIKUBE_HOME=/goinfre/$USER" >> $HOME/.zshrc
				source $HOME/.zshrc
			fi
		fi
	else
		echo ""$GREEN"\n🐳 docker running ..."$NONE""
		open -a docker
		echo ""$CYAN"\n♻️  clean old minikube if exist ..."$NONE""
		minikube delete
	fi
}

# SCRIPT

if [ $# -lt 1 ] || [ $1 = 'run' ] || [ $1 = 'relaunch' ] ; then
	if [ $(uname) = "Linux" ] ; then

		# install minikube
		minikube_linux

		# run minikube
		echo ""$CYAN"\n🛳 minikube running ..."$NONE""
		minikube start --vm-driver=docker
	elif [ $(uname) = "Darwin" ] ; then

		# install minikube
		minikube_macos

		# run minikube
		echo ""$GREEN"\n🛳  minikube running ..."$NONE""
		minikube start --vm-driver=virtualbox --memory=2g --cpus=2 || echo ""$RED"Try the command \"minikube delete\" if failed and relaunch the script."$NONE""
	fi

	# enable dashboard plugin
	echo ""$GREEN"Enabling dashboard ..."$NONE""
	minikube addons enable dashboard

	# tips
	echo ""$YELLOW"\n✅ Lauch the command \"minikube delete\" to clean minikube when finished ✅\n"$NONE""

	# reopen a new zsh because configuration of source ~/.zshrc isn't applicate on old zsh.
	zsh

elif [ $# -eq 1 ] && [ $1 = 'delete' ] ; then

	# delete minikube
	if which minikube 2>/dev/null 1>&2 ; then
		echo ""$CYAN"\n♻️  clean minikube ..."$NONE""
		minikube delete
	fi

elif [ $# -eq 1 ] && [ $1 = 'install' ] ; then
	if [ $(uname) = "Linux" ] ; then

		# install minikube
		minikube_linux
	elif [ $(uname) = "Darwin" ] ; then

		# install minikube
		minikube_macos
	fi

elif [ $# -eq 1 ] && [ $1 = 'clean_all' ] ; then
	if [ $(uname) = "Linux" ] ; then

		# delete minikube
		if which minikube 2>/dev/null 1>&2 ; then
			echo ""$CYAN"\n♻️  clean minikube ..."$NONE""
			minikube delete
		fi

		# delete minikube folder
		echo ""$CYAN"\n♻️  clean minikube folder ..."$NONE""
		rm -rf $HOME/.kube
		rm -rf $HOME/.minikube
	elif [ $(uname) = "Darwin" ] ; then

		# delete minikube
		if which minikube 2>/dev/null 1>&2 ; then
			echo ""$CYAN"\n♻️  clean minikube ..."$NONE""
			minikube delete
		fi

		# delete minikube folder
		echo ""$CYAN"\n♻️  clean minikube folder ..."$NONE""
		rm -rf $HOME/.kube
		rm -rf $HOME/.minikube

		# delete minikube app
		echo ""$CYAN"\n♻️  clean minikube app ..."$NONE""
		brew uninstall minikube
		brew uninstall kubernetes-cli
	fi
fi
