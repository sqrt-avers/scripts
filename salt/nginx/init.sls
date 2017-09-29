nginx:
  pkg:
    - installed

nginx_run:
  service.running:
    - name: nginx
    - enable: True
    - watch:
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/sites-available/test
    - require:
      - file: /etc/nginx/sites-enabled/test
      - file: /etc/nginx/nginx.conf
      - pkg: nginx

/etc/nginx/nginx.conf:
  file:
    - managed
    - source: salt://test/files/nginx.conf
    - user: root
    - group: root
    - mode: 644

/etc/nginx/sites-available/test:
  file:
    - managed
    - source: salt://test/files/test.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: nginx

/etc/nginx/sites-enabled/test:
  file.symlink:
    - target: /etc/nginx/sites-available/test
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/nginx/sites-available/test

/etc/nginx/sites-enabled/default:
  file.absent:
    - name: /etc/nginx/sites-enabled/default
    - require:
      - pkg: nginx

/usr/share/nginx/html/index.php:
  cmd.run:
    - name: echo -e '<?php\nphpinfo();\n?>' > /usr/share/nginx/html/index.php
