apt-get update
apt-get install ca-certificates -y

echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list
echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list
echo "deb http://mirror.edatel.net.co/mariadb/repo/10.1/debian jessie main" >> /etc/apt/sources.list
echo "deb-src http://mirror.edatel.net.co/mariadb/repo/10.1/debian jessie main" >> /etc/apt/sources.list

wget https://www.dotdeb.org/dotdeb.gpg
apt-key add dotdeb.gpg
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
apt-get update
apt-get install git -y

apt-get install -y php7.0-fpm fcgiwrap mcrypt php7.0-mysql php7.0-memcached php7.0-zip php7.0-pspell php7.0-recode php7.0-json php7.0-opcache php7.0-curl php7.0-gd php7.0-intl php-pear php7.0-imagick php7.0-imap php7.0-mcrypt php7.0-mbstring php7.0-sqlite php7.0-tidy php7.0-xmlrpc php7.0-xsl php7.0-redis memcached

cp /etc/php/7.0/fpm/php.ini /etc/php/7.0/fpm/php.ini.BACK
sed -i 's/max_execution_time = 30/max_execution_time = 120/' /etc/php/7.0/fpm/php.ini
sed -i 's/; max_input_vars = 1000/max_input_vars = 3000/' /etc/php/7.0/fpm/php.ini
#sed -i 's/memory_limit = 128M/memory_limit = 96M/' /etc/php/7.0/fpm/php.ini
sed -i 's/max_input_time = 60/max_input_time = 120/' /etc/php/7.0/fpm/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 50M/' /etc/php/7.0/fpm/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 50M/' /etc/php/7.0/fpm/php.ini
sed -i 's/expose_php = On/expose_php = Off/' /etc/php/7.0/fpm/php.ini
sed -i 's/;realpath_cache_size = 16k/realpath_cache_size = 512k/' /etc/php/7.0/fpm/php.ini
sed -i 's/;realpath_cache_ttl = 120/realpath_cache_ttl = 86400/' /etc/php/7.0/fpm/php.ini
sed -i 's/short_open_tag = Off/short_open_tag = On/' /etc/php/7.0/fpm/php.ini
sed -i 's/session.gc_maxlifetime = 1440/session.gc_maxlifetime = 86400/' /etc/php/7.0/fpm/php.ini
sed -i 's/;date.timezone =/date.timezone = UTC/' /etc/php/7.0/fpm/php.ini
sed -i 's/^;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/7.0/fpm/php.ini

cp /etc/php/7.0/fpm/pool.d/www.conf /etc/php/7.0/fpm/pool.d/www.conf.BACK
sed -i 's/;catch_workers_output = yes/catch_workers_output = yes/' /etc/php/7.0/fpm/pool.d/www.conf
sed -i 's/;request_terminate_timeout = 0/request_terminate_timeout = 120s/' /etc/php/7.0/fpm/pool.d/www.conf
sed -i 's/;rlimit_files = 1024/rlimit_files = 200000/' /etc/php/7.0/fpm/pool.d/www.conf
sed -i 's/;rlimit_core = 0/rlimit_core = unlimited/' /etc/php/7.0/fpm/pool.d/www.conf
#sed -i 's/;slowlog = log/$pool.log.slow/slowlog = /var/log/slowlog-site.log/' /etc/php/7.0/fpm/pool.d/www.conf
#sed -i 's/;request_slowlog_timeout = 0/request_slowlog_timeout = 5s/' /etc/php/7.0/fpm/pool.d/www.conf
#sed -i 's/;pm.status_path = /status/pm.status_path = /status/' /etc/php/7.0/fpm/pool.d/www.conf

sed -i 's/;listen.backlog = 65535/listen.backlog = -1/' /etc/php/7.0/fpm/pool.d/www.conf
sed -i 's/;emergency_restart_threshold = 0/emergency_restart_threshold = 10/' /etc/php/7.0/fpm/php-fpm.conf
sed -i 's/;emergency_restart_interval = 0/emergency_restart_interval = 1m/' /etc/php/7.0/fpm/php-fpm.conf
sed -i 's/;process_control_timeout = 0/process_control_timeout = 10s/' /etc/php/7.0/fpm/php-fpm.conf

cd /usr/share && wget https://files.phpmyadmin.net/phpMyAdmin/4.6.3/phpMyAdmin-4.6.3-all-languages.zip && apt-get install zip unzip && unzip phpMyAdmin-4.6.3-all-languages.zip && mv phpMyAdmin-4.6.3-all-languages phpmyadmin

cat > /etc/my.cnf <<EOF
# Generated by Percona Configuration Wizard (http://tools.percona.com/) version REL5-20120208
 
[mysql]
 
# CLIENT #
port                           = 3306
socket                         = /var/run/mysqld/mysqld.sock
 
[mysqld]
 
# GENERAL #
user                           = mysql
default-storage-engine         = InnoDB
socket                         = /var/run/mysqld/mysqld.sock
pid-file                       = /var/run/mysqld/mysqld.pid
tmpdir                         = /tmp
 
# MyISAM #
key-buffer-size                = 32M
myisam-recover                 = FORCE,BACKUP
 
# SAFETY #
max-allowed-packet             = 16M
max-connect-errors             = 1000000
skip-name-resolve
sysdate-is-now                 = 1
innodb                         = FORCE
innodb-strict-mode             = 1
 
sql-mode="NO_ENGINE_SUBSTITUTION"
# DATA STORAGE #
datadir                        = /var/lib/mysql
 
# CACHES AND LIMITS #
tmp-table-size                 = 16M
max-heap-table-size            = 16M
query-cache-type               = 1
query-cache-size               = 16M
max-connections                = 300
thread-cache-size              = 50
open-files-limit               = 65535
table-definition-cache         = 1024
table-open-cache               = 2048
 
# INNODB #
innodb-flush-method            = O_DIRECT
innodb-log-files-in-group      = 2
innodb-log-file-size           = 128M
innodb-flush-log-at-trx-commit = 2
innodb-file-per-table          = 1
innodb-buffer-pool-size        = 128M
innodb_fast_shutdown           = 0
 
# LOGGING #
log-error                      = /var/log/mysql/mysql-error.log
log-queries-not-using-indexes  = 0
slow-query-log                 = 1
slow-query-log-file            = /var/log/mysql/mysql-slow.log
 
# REDUCE MEMORY USAGE #
performance_schema             = 0
EOF

apt-get install mariadb-server -y
mv /etc/my.cnf /etc/mysql/my.cnf
/etc/init.d/mysql restart
