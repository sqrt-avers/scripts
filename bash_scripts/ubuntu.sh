 #!/bin/bash


#hostname

hostnamectl set-hostname ALEX.SERVER
service hostname restart

#time

apt-get install -y ntp
echo "server  pool.ntp.org" >> /etc/ntp.conf
service ntp restart

#install updates

apt-get -y update
apt-get -y upgrade

#install soft

apt-get install -y git && nmap && sockstat && expect
apt-get install -y autoconf && automake && build-essential && g++-4.8 && gcc-4.8 && unzip && zlib1g-dev
apt-get install -y python && python-pip && python-software-properties

#install and config supervisors

apt-get install -y supervisor

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

service supervisord start

#install MySQL

debconf-set-selections <<< 'mysql-server mysql-server/root_password password devroot'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password devroot'
apt-get install -y mysql-server && mysql-client

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

#install apache and php5

apt-get install -y apache2 && php5 && libapache2-mod-php5

service apache2 restart

apt-get install -y php5-mysql && php5-curl && php5-gd && php5-intl && php5-imagick && php5-imap && php5-mcrypt && php5-ming && php5-ps && php5-recode && php5-snmp && php5-sqlite && php5-tidy && php5-xmlrpc && php5-xsl && php5-json && php5-xcache && php5-dev && php5-cgi #php extensions

service apache2 restart

#check php

touch /var/www/html/test.php
chmod 777 /var/www/html/test.php
echo "<?php phpinfo(); ?>">>/var/www/html/test.php

#generate Lets Encrypth keys and configure apache virtualhosts

service apache2 stop

git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt

cd /opt/letsencrypt

./letsencrypt-auto certonly --standalone -d devops2.chdev.com.ua -d www.devops2.chdev.com.ua

cat <<EOT > /etc/apache2/sites-available/devops2.chdev.com.ua-ssl.conf
Listen 443
RewriteEngine on

<VirtualHost *:80>
    ServerName www.devops2.chdev.com.ua
    ServerAlias devops2.chdev.com.ua
    RewriteEngine on

    RewriteRule ^(/.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]


<IfModule mod_ssl.c>
        <VirtualHost _default_:443>
                ServerAdmin
                ServerName devops2.chdev.com.ua

                DocumentRoot /var/www/html
                <Directory />
                        Options FollowSymLinks
                        AllowOverride All
                </Directory>
                <Directory /var/www/html/>
                        Options Indexes FollowSymLinks MultiViews
                        AllowOverride All
                        Order allow,deny
                        allow from all
                </Directory>

                ErrorLog /error.log
                CustomLog /access.log combined
                SSLEngine on
                SSLCertificateFile      /etc/letsencrypt/live/devops2.chdev.com.ua/cert.pem
                SSLCertificateKeyFile   /etc/letsencrypt/live/devops2.chdev.com.ua/privkey.pem
                <FilesMatch "\.(cgi|shtml|phtml|php)$">
                                SSLOptions +StdEnvVars
                </FilesMatch>
                <Directory /usr/lib/cgi-bin>
                                SSLOptions +StdEnvVars
                </Directory>
                BrowserMatch "MSIE [2-6]" \
                             nokeepalive ssl-unclean-shutdown \
                             downgrade-1.0 force-response-1.0
                BrowserMatch "MSIE [17-9]" ssl-unclean-shutdown
        </VirtualHost>
</IfModule>
EOT
service apache2 start
