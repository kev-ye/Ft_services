# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    debug.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: kaye <kaye@student.42.fr>                  +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/04/16 19:09:15 by kaye              #+#    #+#              #
#    Updated: 2021/04/21 11:29:27 by kaye             ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

if [ $# -eq 1 ] && [ $1 = 'run' ] ; then
	if ! docker network ls | grep test ; then
		docker network create test
	fi
	# docker run -it -p 80:80 -p 443:443 -p 22:22 --name nginx nginx
	docker run -it --network test -p 80:80 -p 443:443 --name nginx nginx
elif [ $# -eq 1 ] && [ $1 = 'build' ] ; then
	docker build -t nginx .
elif [ $# -eq 1 ] && [ $1 = 'clean' ] ; then
	docker container kill nginx
	docker container rm nginx
	docker image rm nginx
fi