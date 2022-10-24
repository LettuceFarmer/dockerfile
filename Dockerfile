FROM ubuntu:20.04
RUN apt-get update && apt-get upgrade -y

#Services and programs installation

#Python 3.10
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get install python3.10 -y

#Apache 2
RUN apt-get install apache2 -y
RUN apt-get install ufw -y
RUN apt-get install iptables -y
RUN ufw allow 'Apache'

#mySQL
RUN apt-get install mysql-server -y

#SSH
RUN apt-get install openssh-server -y
RUN systemctl enable ssh
RUN service ssh start

#supervisor
RUN apt-get install supervisor -y

#Supervisor configuration
RUN touch /etc/supervisor/conf.d/supervisord.conf
RUN echo "[supervisord]" > /etc/supervisor/conf.d/supervisord.conf
RUN echo "nodaemon=true" >> /etc/supervisor/conf.d/supervisord.conf
#Ssh
RUN echo "[program:ssh]" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "command=/usr/sbin/sshd -D" >> /etc/supervisor/conf.d/supervisord.conf
#Apache2
RUN echo "[program:apache2]" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "command=/usr/sbin/apache2ctl -DFOREGROUND" >> /etc/supervisor/conf.d/supervisord.conf

#mySQL
RUN echo "[program:mysql]" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "command=/usr/bin/pidproxy /var/run/mysqld/mysqld.pid /etc/init.d/mysql start" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "autostart=true" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "autorestart=true" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "user=root" >> /etc/supervisor/conf.d/supervisord.conf

EXPOSE 22 80 443 3306 9001
CMD ["/usr/bin/supervisord"]
