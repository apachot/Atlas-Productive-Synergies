#!/bin/bash

echo "============================================================="
echo "Récupération et installation de PostgreSQL et des extensions."
echo "Powered by Doud"

echo "=== Récupération du code source ==="
wget https://ftp.postgresql.org/pub/source/v12.3/postgresql-12.3.tar.gz
gunzip postgresql-12.3.tar.gz
tar xf postgresql-12.3.tar
rm postgresql-12.3.tar
echo -e "\n\n"


echo "=== Build et installation ==="
cd postgresql-12.3
./configure --with-systemd
make
sudo make install

cd contrib
make
sudo make install
echo -e "\n\n"


echo "=== Parametrage ==="
sudo adduser postgres 
sudo mkdir /usr/local/pgsql/data
sudo chown postgres /usr/local/pgsql/data
echo -e "\tCréation d'e l'utilisateur courant"
/usr/local/pgsql/bin/createuser -s -P
sudo su - postgres
/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data
echo -e "\n\n"


echo "=== execution de postgres"
/usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data >logfile 2>&1 &
sudo echo " 
[Unit]
Description=PostgresSQL database server
Documentation=man:postgres(1)

[Service]
Type=notify
User=postgres
ExecStart=/usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data
ExecReload=/bin/kill -HUP $MAINPID
KillMode=mixed
KillSignal=SIGINT
TimeoutSec=0

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/postgresql.service
echo -e "\n\n"


echo "=== création d'une base phoenix ==="
/usr/local/pgsql/bin/createdb phoenix
/usr/local/pgsql/bin/psql phoenix -c "CREATE EXTENSION hstore;"
echo -e "\n\n"

echo "pour plus de simplicité ajouter '/usr/local/pgsql/bin' à votre PATH bashrc"
echo -e "Pour créer une base de données : 
	createdb MA_BASE
	pgsql MA_BASE
	CREATE EXTENSION hstore;
"
