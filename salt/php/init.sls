php7.0:
  pkg.installed:
    - name: php7.0

php7.0-fpm:
  pkg.installed:
    - name: php7.0-fpm

/etc/php/7.0/fpm/php.ini:
  cmd.run:
    - name: sed -i 's/;cgi.fix_pathinfo = 1/cgi.fix_pathinfo = 0/g' /etc/php/7.0/fpm/php.ini
        
/etc/init.d/php7.0-fpm restart:
  cmd.run:
    - name: /etc/init.d/php7.0-fpm restart

/etc/init.d/nginx restart:
  cmd.run:
    - name: /etc/init.d/nginx restart

