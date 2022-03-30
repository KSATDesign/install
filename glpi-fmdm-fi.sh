#!/usr/bin/env bash

sudo yum -y install http://mirror.de-labrusse.fr/NethServer/7/x86_64/nethserver-stephdl-1.1.9-1.ns7.sdl.noarch.rpm

sudo yum -y install nethserver-glpi-latest mysql-devel gcc automake autoconf libtool make unzip git composer mosquitto mosquitto-clients mosquitto-dev openssl-perl

mosquitto -h | head -n 1 > mos.txt && sed -i "s/mosquitto version /mosquitto-/" mos.txt

wget http://mosquitto.org/files/source/$(cat ~/mos.txt).tar.gz

mkdir ~/mosquitto && tar xCz ~/mosquitto -f mosquitto*.tar.gz && git clone https://github.com/KSATDesign/mosquitto-auth-plug.git && mv mosquitto-auth-plug /usr/lib/mosquitto-auth-plug

cd /usr/lib/mosquitto-auth-plug/

make

mkdir /etc/mosquitto/conf.d/

echo "allow_anonymous false

auth_plugin /usr/lib/mosquitto-auth-plug/auth-plug.so

auth_opt_backends mysql

auth_opt_host localhost

auth_opt_port 8105

auth_opt_user glpi

auth_opt_dbname glpi

auth_opt_pass $(cat /var/lib/nethserver/secrets/glpi)

auth_opt_userquery SELECT password FROM glpi_plugin_flyvemdm_mqttusers WHERE user='%s' AND enabled='1'

auth_opt_aclquery SELECT topic FROM glpi_plugin_flyvemdm_mqttacls a LEFT JOIN glpi_plugin_flyvemdm_mqttusers u ON (a.plugin_flyvemdm_mqttusers_id = u.id) WHERE u.user='%s' AND u.enabled='1' AND (a.access_level & %d)

auth_opt_cacheseconds 300

listener 8883

cafile /etc/mosquitto/certs/cachain.pem

certfile /etc/mosquitto/certs/cachain.pem

keyfile /etc/mosquitto/certs/private-key.key

tls_version tlsv1.2

ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:ECDHE-ECDSA-RC4-SHA:AES128:AES256:HIGH:!RC4:!aNULL:!eNULL:!EXPORT:!DES:!3DES:!MD5:!PSK
" > /etc/mosquitto/conf.d/flyvemdm.conf

sudo yum -y install http://mirror.de-labrusse.fr/NethServer/7/x86_64/nethserver-stephdl-1.1.9-1.ns7.sdl.noarch.rpm

sudo yum -y install nethserver-glpi-latest mysql-devel gcc automake autoconf libtool make unzip git composer mosquitto mosquitto-clients mosquitto-dev

mosquitto -h | head -n 1 > mos.txt && sed -i "s/mosquitto version /mosquitto-/" mos.txt

wget http://mosquitto.org/files/source/$(cat ~/mos.txt).tar.gz

mkdir ~/mosquitto && tar xCz ~/mosquitto -f mosquitto*.tar.gz && git clone https://github.com/KSATDesign/mosquitto-auth-plug.git && mv mosquitto-auth-plug /usr/lib/mosquitto-auth-plug

cd /usr/lib/mosquitto-auth-plug/

make

mkdir /etc/mosquitto/conf.d/

mkdir /etc/Jobs

cat <<EOF >>/etc/Jobs/certmove.sh

#!/usr/bin/bash

sudo cp /etc/letsencrypt/live/$(hostname --fqdn)/fullchain.pem /etc/mosquitto/certs/cachain.pem

sudo cp /etc/letsencrypt/live/$(hostname --fqdn)/privkey.pem /etc/mosquitto/certs/private-key.key

sudo chmod 600 /etc/mosquitto/certs/private-key.key

sudo chown mosquitto:root /etc/mosquitto/certs/private-key.key

sudo c_rehash /etc/mosquitto/certs

sudo systemctl restart mosquitto

echo "done"

EOF

echo "allow_anonymous false

auth_plugin /usr/lib/mosquitto-auth-plug/auth-plug.so

auth_opt_backends mysql

auth_opt_host localhost

auth_opt_port 3306

auth_opt_user glpi

auth_opt_dbname glpidb

auth_opt_pass $(cat /var/lib/nethserver/secrets/glpi)

auth_opt_userquery SELECT password FROM glpi_plugin_flyvemdm_mqttusers WHERE user='%s' AND enabled='1'

auth_opt_aclquery SELECT topic FROM glpi_plugin_flyvemdm_mqttacls a LEFT JOIN glpi_plugin_flyvemdm_mqttusers u ON (a.plugin_flyvemdm_mqttusers_id = u.id) WHERE u.user='%s' AND u.enabled='1' AND (a.access_level & %d)

auth_opt_cacheseconds 300

listener 8883

cafile /etc/mosquitto/certs/cachain.pem

certfile /etc/mosquitto/certs/cachain.pem

keyfile /etc/mosquitto/certs/private-key.key

tls_version tlsv1.2

ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:ECDHE-ECDSA-RC4-SHA:AES128:AES256:HIGH:!RC4:!aNULL:!eNULL:!EXPORT:!DES:!3DES:!MD5:!PSK
" > /etc/mosquitto/conf.d/flyvemdm.conf

echo "15 3 * * * certbot renew --noninteractive --post-hook "/etc/Jobs/certmove.sh"

* * * * * /usr/bin/php7.3 /usr/share/glpi/front/cron.php &>/dev/null " >> /etc/crontab

systemctl reload crond 

sed -i '4 i alias composer="php73 /bin/composer"' ~/.bashrc

source ~/.bashrc

git clone https://github.com/fusioninventory/fusioninventory-for-glpi.git /usr/share/glpi/plugins/fusioninventory
git clone https://github.com/flyve-mdm/glpi-plugin.git /usr/share/glpi/plugins/flyvemdm


cd /usr/share/glpi/plugins/fusioninventory
make clean
make
composer install

cd /usr/share/glpi/plugins/flyvemdm

composer init
make clean
make
composer install
cd ~

cat <<EOF >>/etc/systemd/system/flyvemdm.service

[Unit]
Description=Flyve Mobile Device Management for GLPI
Wants=network.target
##########################################################################
ConditionPathExists=/usr/share/glpi/plugins/flyvemdm/scripts/mqtt.php
##########################################################################

[Service]
Type=simple
User=httpd
Group=httpd
ExecStart=/usr/share/glpi/plugins/flyvemdm/scripts/loop-run.sh
Restart=on-failure
SyslogIdentifier=flyvemdm
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start flyvemdm.service
systemctl enable flyvemdm.service

cat <<EOF >>~/S80push2ad
cp -f -p /etc/pki/tls/certs/localhost.crt  /var/lib/machines/nsdc/var/lib/samba/private/tls/cert.pem
cp -f -p /etc/pki/tls/private/localhost.key  /var/lib/machines/nsdc/var/lib/samba/private/tls/key.pem
chmod 600 /var/lib/machines/nsdc/var/lib/samba/private/tls/key.pem
chmod 644 /var/lib/machines/nsdc/var/lib/samba/private/tls/cert.pem
systemctl -M nsdc restart samba
EOF

read -r -p "Do you need to use strong authentication using your Letsencrypt AD Certificate to bind to your AD/LDAP? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        mv ~/S80push2ad /etc/e-smith/events/certificate-update/S80push2ad && rm -fR ~/mosquitto
        ;;
    *)
        rm -fR ~/mosquitto
        ;;
esac

echo "your installation is complete please go to the web interface https://$(hostname --fqdn)/glpi to complete the configuration"

sudo yum -y install http://mirror.de-labrusse.fr/NethServer/7/x86_64/nethserver-stephdl-1.1.9-1.ns7.sdl.noarch.rpm

sudo yum -y install nethserver-glpi-latest mysql-devel gcc automake autoconf libtool make unzip git composer mosquitto mosquitto-clients mosquitto-dev

mosquitto -h | head -n 1 > mos.txt && sed -i "s/mosquitto version /mosquitto-/" mos.txt

wget http://mosquitto.org/files/source/$(cat ~/mos.txt).tar.gz

mkdir ~/mosquitto && tar xCz ~/mosquitto -f mosquitto*.tar.gz && git clone https://github.com/KSATDesign/mosquitto-auth-plug.git && mv mosquitto-auth-plug /usr/lib/mosquitto-auth-plug

cd /usr/lib/mosquitto-auth-plug/

make

mkdir /etc/mosquitto/conf.d/

mkdir /etc/Jobs

cat <<EOF >>/etc/Jobs/certmove.sh

#!/usr/bin/bash

sudo cp /etc/letsencrypt/live/$(hostname --fqdn)/fullchain.pem /etc/mosquitto/certs/cachain.pem

sudo cp /etc/letsencrypt/live/$(hostname --fqdn)/privkey.pem /etc/mosquitto/certs/private-key.key

sudo chmod 600 /etc/mosquitto/certs/private-key.key

sudo chown mosquitto:root /etc/mosquitto/certs/private-key.key

sudo c_rehash /etc/mosquitto/certs

sudo systemctl restart mosquitto

echo "done"

EOF

echo "allow_anonymous false

auth_plugin /usr/lib/mosquitto-auth-plug/auth-plug.so

auth_opt_backends mysql

auth_opt_host localhost

auth_opt_port 3306

auth_opt_user glpi

auth_opt_dbname glpidb

auth_opt_pass $(cat /var/lib/nethserver/secrets/glpi)

auth_opt_userquery SELECT password FROM glpi_plugin_flyvemdm_mqttusers WHERE user='%s' AND enabled='1'

auth_opt_aclquery SELECT topic FROM glpi_plugin_flyvemdm_mqttacls a LEFT JOIN glpi_plugin_flyvemdm_mqttusers u ON (a.plugin_flyvemdm_mqttusers_id = u.id) WHERE u.user='%s' AND u.enabled='1' AND (a.access_level & %d)

auth_opt_cacheseconds 300

listener 8883

cafile /etc/mosquitto/certs/cachain.pem

certfile /etc/mosquitto/certs/cachain.pem

keyfile /etc/mosquitto/certs/private-key.key

tls_version tlsv1.2

ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:ECDHE-ECDSA-RC4-SHA:AES128:AES256:HIGH:!RC4:!aNULL:!eNULL:!EXPORT:!DES:!3DES:!MD5:!PSK
" > /etc/mosquitto/conf.d/flyvemdm.conf

echo "15 3 * * * certbot renew --noninteractive --post-hook "/etc/Jobs/certmove.sh"

* * * * * /usr/bin/php7.3 /var/lib/nethserver/vhost/virtualhostrootdirectory/glpi/front/cron.php &>/dev/null " >> /etc/crontab

systemctl reload crond 

sed -i '4 i alias composer="php73 /bin/composer"' ~/.bashrc

source ~/.bashrc

git clone https://github.com/fusioninventory/fusioninventory-for-glpi.git /usr/share/glpi/plugins/fusioninventory
git clone https://github.com/flyve-mdm/glpi-plugin.git /usr/share/glpi/plugins/flyvemdm


cd /usr/share/glpi/plugins/fusioninventory
make clean
make
composer install

cd /usr/share/glpi/plugins/flyvemdm

composer init
make clean
make
composer install
cd ~

cat <<EOF >>/etc/systemd/system/flyvemdm.service

[Unit]
Description=Flyve Mobile Device Management for GLPI
Wants=network.target
##########################################################################
ConditionPathExists=/usr/share/glpi/plugins/flyvemdm/scripts/mqtt.php
##########################################################################

[Service]
Type=simple
User=httpd
Group=httpd
ExecStart=/usr/share/glpi/plugins/flyvemdm/scripts/loop-run.sh
Restart=on-failure
SyslogIdentifier=flyvemdm
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start flyvemdm.service
systemctl enable flyvemdm.service

cat <<EOF >>~/S80push2ad
cp -f -p /etc/pki/tls/certs/localhost.crt  /var/lib/machines/nsdc/var/lib/samba/private/tls/cert.pem
cp -f -p /etc/pki/tls/private/localhost.key  /var/lib/machines/nsdc/var/lib/samba/private/tls/key.pem
chmod 600 /var/lib/machines/nsdc/var/lib/samba/private/tls/key.pem
chmod 644 /var/lib/machines/nsdc/var/lib/samba/private/tls/cert.pem
systemctl -M nsdc restart samba
EOF

read -r -p "Do you need to use strong authentication using your Letsencrypt AD Certificate to bind to your AD/LDAP? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        mv ~/S80push2ad /etc/e-smith/events/certificate-update/S80push2ad && rm -fR ~/mosquitto
        ;;
    *)
        rm -fR ~/mosquitto
        ;;
esac

echo "your installation is complete please go to the web interface https://$(hostname --fqdn)/glpi to complete the configuration"

sudo yum -y install http://mirror.de-labrusse.fr/NethServer/7/x86_64/nethserver-stephdl-1.1.9-1.ns7.sdl.noarch.rpm

sudo yum -y install nethserver-glpi-latest mysql-devel gcc automake autoconf libtool make unzip git composer mosquitto mosquitto-clients mosquitto-dev

mosquitto -h | head -n 1 > mos.txt && sed -i "s/mosquitto version /mosquitto-/" mos.txt

wget http://mosquitto.org/files/source/$(cat ~/mos.txt).tar.gz

mkdir ~/mosquitto && tar xCz ~/mosquitto -f mosquitto*.tar.gz && git clone https://github.com/KSATDesign/mosquitto-auth-plug.git && mv mosquitto-auth-plug /usr/lib/mosquitto-auth-plug

cd /usr/lib/mosquitto-auth-plug/

make

mkdir /etc/mosquitto/conf.d/

mkdir /etc/Jobs

cat <<EOF >>/etc/Jobs/certmove.sh

#!/usr/bin/bash

sudo cp /etc/letsencrypt/live/yourdomain.tld/fullchain.pem /etc/mosquitto/certs/cachain.pem

sudo cp /etc/letsencrypt/live/yourdomain.tld/privkey.pem /etc/mosquitto/certs/private-key.key

sudo chmod 600 /etc/mosquitto/certs/private-key.key

sudo chown mosquitto:root /etc/mosquitto/certs/private-key.key

sudo c_rehash /etc/mosquitto/certs

sudo systemctl restart mosquitto

echo "done"

EOF

echo "allow_anonymous false

auth_plugin /usr/lib/mosquitto-auth-plug/auth-plug.so

auth_opt_backends mysql

auth_opt_host localhost

auth_opt_port 3306

auth_opt_user glpi

auth_opt_dbname glpidb

auth_opt_pass $(cat /var/lib/nethserver/secrets/glpi)

auth_opt_userquery SELECT password FROM glpi_plugin_flyvemdm_mqttusers WHERE user='%s' AND enabled='1'

auth_opt_aclquery SELECT topic FROM glpi_plugin_flyvemdm_mqttacls a LEFT JOIN glpi_plugin_flyvemdm_mqttusers u ON (a.plugin_flyvemdm_mqttusers_id = u.id) WHERE u.user='%s' AND u.enabled='1' AND (a.access_level & %d)

auth_opt_cacheseconds 300

listener 8883

cafile /etc/mosquitto/certs/cachain.pem

certfile /etc/mosquitto/certs/cachain.pem

keyfile /etc/mosquitto/certs/private-key.key

tls_version tlsv1.2

ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:ECDHE-ECDSA-RC4-SHA:AES128:AES256:HIGH:!RC4:!aNULL:!eNULL:!EXPORT:!DES:!3DES:!MD5:!PSK
" > /etc/mosquitto/conf.d/flyvemdm.conf

echo "15 3 * * * certbot renew --noninteractive --post-hook "/etc/Jobs/certmove.sh"

* * * * * /usr/bin/php7.3 /var/lib/nethserver/vhost/virtualhostrootdirectory/glpi/front/cron.php &>/dev/null " >> /etc/crontab

systemctl reload crond 

sed -i '4 i alias composer="php73 /bin/composer"' ~/.bashrc

source ~/.bashrc

git clone https://github.com/fusioninventory/fusioninventory-for-glpi.git /usr/share/glpi/plugins/fusioninventory
git clone https://github.com/flyve-mdm/glpi-plugin.git /usr/share/glpi/plugins/flyvemdm


cd /usr/share/glpi/plugins/fusioninventory
make clean
make
composer install

cd /usr/share/glpi/plugins/flyvemdm

composer init
make clean
make
composer install
cd ~

cat <<EOF >>/etc/systemd/system/flyvemdm.service

[Unit]
Description=Flyve Mobile Device Management for GLPI
Wants=network.target
##########################################################################
ConditionPathExists=/usr/share/glpi/plugins/flyvemdm/scripts/mqtt.php
##########################################################################

[Service]
Type=simple
User=httpd
Group=httpd
ExecStart=/usr/share/glpi/plugins/flyvemdm/scripts/loop-run.sh
Restart=on-failure
SyslogIdentifier=flyvemdm
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start flyvemdm.service
systemctl enable flyvemdm.service

cat <<EOF >>~/S80push2ad
cp -f -p /etc/pki/tls/certs/localhost.crt  /var/lib/machines/nsdc/var/lib/samba/private/tls/cert.pem
cp -f -p /etc/pki/tls/private/localhost.key  /var/lib/machines/nsdc/var/lib/samba/private/tls/key.pem
chmod 600 /var/lib/machines/nsdc/var/lib/samba/private/tls/key.pem
chmod 644 /var/lib/machines/nsdc/var/lib/samba/private/tls/cert.pem
systemctl -M nsdc restart samba
EOF

read -r -p "Do you need to use strong authentication using your Letsencrypt AD Certificate to bind to your AD/LDAP? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        mv ~/S80push2ad /etc/e-smith/events/certificate-update/S80push2ad && rm -fR ~/mosquitto
        ;;
    *)
        rm -fR ~/mosquitto
        ;;
esac

echo "your installation is complete please go to the web interface https://$(hostname --fqdn)/glpi to complete the configuration"

keyfile /etc/mosquitto/certs/private-key.key

tls_version tlsv1.2

ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:ECDHE-ECDSA-RC4-SHA:AES128:AES256:HIGH:!RC4:!aNULL:!eNULL:!EXPORT:!DES:!3DES:!MD5:!PSK
" > /etc/mosquitto/conf.d/flyvemdm.conf

echo "15 3 * * * certbot renew --noninteractive --post-hook "/etc/Jobs/certmove.sh"

* * * * * /usr/bin/php7.3 /var/lib/nethserver/vhost/virtualhostrootdirectory/glpi/front/cron.php &>/dev/null " >> /etc/crontab

systemctl reload crond 

sed -i '4 i alias composer="php73 /bin/composer"' ~/.bashrc

source ~/.bashrc

git clone https://github.com/fusioninventory/fusioninventory-for-glpi.git /usr/share/glpi/plugins/fusioninventory
git clone https://github.com/flyve-mdm/glpi-plugin.git /usr/share/glpi/plugins/flyvemdm


cd /usr/share/glpi/plugins/fusioninventory
make clean
make
yes | composer install

cd /usr/share/glpi/plugins/flyvemdm

composer init
wait
make clean
make
yes | composer install
cd ~

cat <<EOF >>/etc/systemd/system/flyvemdm.service

[Unit]
Description=Flyve Mobile Device Management for GLPI
Wants=network.target
##########################################################################
ConditionPathExists=/usr/share/glpi/plugins/flyvemdm/scripts/mqtt.php
##########################################################################

[Service]
Type=simple
User=httpd
Group=httpd
ExecStart=/usr/share/glpi/plugins/flyvemdm/scripts/loop-run.sh
Restart=on-failure
SyslogIdentifier=flyvemdm
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start flyvemdm.service
systemctl enable flyvemdm.service

cat <<EOF >>~/S80push2ad
cp -f -p /etc/pki/tls/certs/localhost.crt  /var/lib/machines/nsdc/var/lib/samba/private/tls/cert.pem
cp -f -p /etc/pki/tls/private/localhost.key  /var/lib/machines/nsdc/var/lib/samba/private/tls/key.pem
chmod 600 /var/lib/machines/nsdc/var/lib/samba/private/tls/key.pem
chmod 644 /var/lib/machines/nsdc/var/lib/samba/private/tls/cert.pem
systemctl -M nsdc restart samba
EOF

read -r -p "Do you need to use strong authentication using your Letsencrypt AD Certificate to bind to your AD/LDAP? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        mv ~/S80push2ad /etc/e-smith/events/certificate-update/S80push2ad && rm -fR ~/mosquitto
        ;;
    *)
        rm -fR ~/mosquitto
        ;;
esac

echo "your installation is complete please go to the web interface https://$(hostname --fqdn)/glpi to complete the configuration"
