service mysql restart


mysql -p -u root
CREATE USER 'pmauser'@'%' IDENTIFIED BY 'password_here';
GRANT ALL PRIVILEGES ON *.* TO 'pmauser'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

