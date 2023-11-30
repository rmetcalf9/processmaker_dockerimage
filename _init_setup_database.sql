drop database IF EXISTS processmaker;
create database processmaker CHARACTER SET utf8 COLLATE utf8_general_ci;
grant ALL on processmaker.* TO pm@'%' IDENTIFIED BY 'pass';
FLUSH PRIVILEGES;

exit
