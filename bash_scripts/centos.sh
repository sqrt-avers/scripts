#!/bin/bash

#seelinux disabling and add port to firewall

sed -i 's/\(^[^#]*\)SELINUX=enforcing/\1SELINUX=disabled/' /etc/selinux/config

#firewall-cmd --permanent --zone=public --add-port=5522/tcp
#firewall-cmd --reload

#add repos

rpm -ivh https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm
#rpm -ivh https://fedora.ip-connect.vn.ua/fedora-epel/7/x86_64/e/epel-release-7-9.noarch.rpm
rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
rpm -ivh http://dl.atrpms.net/all/atrpms-repo-6-7.el6.x86_64.rpm
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm

#create user and add to sudo
#adduser gorynov
#usermod -aG wheel gorynov

#hostname

hostnamectl set-hostname ALEX.SERVER
service hostname restart

systemctl restart networking.service

#install updates and tools

yum update -y
yum install -y net-tools && mtr && nano

#instal time ntp

yum install -y ntp

ntpdate pool.ntp.org
systemctl ntpd enable
systemctl start ntpd

#install soft

yum install -y git && nmap && sockstat
yum install -y autoconf && gcc.x86_64 && build-essential && unzip && python && python-devel.x86_64 && python2-pip.noarch && python-tools.x86_64
yum install -y supervisor

cat <<EOT > /etc/init/supervisord.conf
description     "supervisord"

start on runlevel [2345]
stop on runlevel [!2345]

respawn

exec /usr/local/bin/supervisord --nodaemon --configuration /etc/supervisord.conf
EOT

cat <<EOT > /bin/supc
#!/bin/bash

supervisorctl --configuration /etc/supervisord.conf
EOT

chmod +x /bin/supc

cat <<EOT > /etc/supervisord.conf
; supervisord configuration file
;
; For more information on the config file, please see:
; http://supervisord.org/configuration.html
;

;*******************************************************************
; socket control: enabled
;*******************************************************************
[unix_http_server]
file=/tmp/supervisor.sock   ; (the path to the socket file)
;chmod=0700                 ; socket file mode (default 0700)
;chown=nobody:nogroup       ; socket file uid:gid owner
username=fb5e9a1040752e84  ; (default is no username (open server))
password=bb24dc41c58f1461  ; (default is no password (open server))

;*******************************************************************
; inet control
;*******************************************************************
;[inet_http_server]         ; inet (TCP) server disabled by default
;port=127.0.0.1:9001        ; (ip_address:port specifier, *:port for all iface)
;username=fb5e9a1040752e84  ; (default is no username (open server))
;password=bb24dc41c58f1461  ; (default is no password (open server))

;*******************************************************************
; supervisord
;*******************************************************************
[supervisord]
logfile=/var/log/supervisord.log ; (main log file;default $CWD/supervisord.log)
logfile_maxbytes=50MB        ; (max main logfile bytes b4 rotation;default 50MB)
logfile_backups=10           ; (num of main logfile rotation backups;default 10)
loglevel=info                ; (log level;default info; others: debug,warn,trace)
pidfile=/var/run/supervisord.pid ; (supervisord pidfile;default supervisord.pid)
nodaemon=false               ; (start in foreground if true;default false)
minfds=1024                  ; (min. avail startup file descriptors;default 1024)
minprocs=200                 ; (min. avail process descriptors;default 200)
;umask=022                   ; (process file creation umask;default 022)
;user=chrism                 ; (default is current user, required if root)
;identifier=supervisor       ; (supervisord identifier, default is 'supervisor')
;directory=/tmp              ; (default is not to cd during start)
;nocleanup=true              ; (don't clean up tempfiles at start;default false)
;childlogdir=/tmp            ; ('AUTO' child log dir, default $TEMP)
;environment=KEY="value"     ; (key value pairs to add to environment)
;strip_ansi=false            ; (strip ansi escape codes in logs; def. false)

; the below section must remain in the config file for RPC
; (supervisorctl/web interface) to work, additional interfaces may be
; added by defining them in separate rpcinterface: sections
[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

;*******************************************************************
; supervisorctl
;*******************************************************************
[supervisorctl]
serverurl=unix:///tmp/supervisor.sock ; use a unix:// URL  for a unix socket
;serverurl=http://127.0.0.1:9001 ; use an http:// url to specify an inet socket
username=fb5e9a1040752e84              ; should be same as http_username if set
password=bb24dc41c58f1461                ; should be same as http_password if set
;prompt=mysupervisor         ; cmd line prompt (default "supervisor")
;history_file=~/.sc_history  ; use readline history if available

;*******************************************************************
; jupyter
;*******************************************************************
; security risk: anyone with server login owns the whole thing
; USE A STRONG PASSWORD, AND RESTRICT INET TO LOCALHOST
[program:jupyter]
command=/root/bin/jup
autostart=false
autorestart=true
startsecs=10
startretries=3
killasgroup=false
stopasgroup=false
redirect_stderr=false
stdout_logfile=/var/log/supervisord_jup.log
stderr_logfile=/var/log/supervisord_jup_err.log
EOT

systemctl start supervisord

#install MySQL

yum install -y mariadb-server
MYSQL_ROOT_PASSWORD=devroot

#MySQL secure installation

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$MYSQL\r\"
expect \"Change the root password?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

echo "$SECURE_MYSQL"

systemctl enable mariadb.service
systemctl start mariadb.service

#install apache and php5

yum install -y httpd && php && php-mysql.x86_64 && php-fpm 

systemctl enable httpd.service
systemctl start httpd.service

#yum install -y php5-mysql && php5-curl && php5-gd && php5-intl && php-pear && php5-imagick && php5-imap && php5-mcrypt && php5-ming && php5-ps && php5-recode && php5-snmp && php5-sqlite && php5-tidy && php5-xmlrpc
#systemctl restart httpd.service

#check php

touch /var/www/html/test.php
chmod 777 /var/www/html/test.php

#generate Lets Encrypth keys and configure apache virtualhosts

systemctl stop httpd

yum install -y openssl && mod_ssl.x86_64 && openssl-devel.x86_64

git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt

cd /opt/letsencrypt

./letsencrypt-auto certonly --standalone -d devops2.chdev.com.ua -d www.devops2.chdev.com.ua

cat apache.cent >> /etc/httpd/httpd.conf

systemctl start httpd
