# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    livenessprobe.sh                                   :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: kaye <kaye@student.42.fr>                  +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/05/09 14:42:02 by kaye              #+#    #+#              #
#    Updated: 2021/05/12 19:17:23 by kaye             ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

if ! service mariadb status | grep "started" ; then
	service mariadb restart
fi