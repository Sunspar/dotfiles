ensure_mariadb() {
    # First-boot setup for MariaDB.
    mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    systemctl enable --now mariadb
}

ensure_postgres() {
    # First-boot setup for PostgreSQL.
    su -c 'initdb --locale=en_US.UTF-8 -E UTF8 -D /var/lib/postgres/data' postgres
    systemctl enable --now postgresql
}

ensure_apache() {
    yay -S apache php php-fpm
    systemctl enable --now php-fpm
    systemctl enable --now httpd
    # NOTE: YOu may also want to enable pdo_mysql, pdo_pgsql, mysqli in /etc/php/php.ini and restart httpd.
}

ensure_mariadb
ensure_postgres
ensure_apache