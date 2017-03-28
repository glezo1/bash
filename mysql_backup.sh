#!/bin/bash
####################################################################################################
#2016/03/27, @glezo1                                                                               #
#dump every database into two files: structure and data.                                           #
#It won't dump 'information_schema' or 'mysql' databases                                           #
#yes, I know. I shouldn't do the plain old -p$password. Just a quick'n dirty backup.               #
####################################################################################################

#CONSTANTS####################################
db_host="localhost"
db_port="3306"
db_user="root"
db_pass="you_know_bro_this_aint_my_password"
backup_parent_directory="/root/mysql_backup"
##############################################

mkdir -p $backup_parent_directory

now_string=`date +"%Y%m%d"`
output_directory=$backup_parent_directory/$now_string
mkdir -p $output_directory

databases_to_dump=`mysql -h $db_host -P $db_port -u $db_user -p$db_pass -e "show databases" | grep -Ev 'Database|information_schema|mysql'`
for current_db in $databases_to_dump
do
  echo $current_db
  mysqldump -h $db_host -P $db_port -u $db_user -p$db_pass --events --routines --triggers --no-data $current_db > $output_directory/$current_db"_STRUCTURE.sql"
  mysqldump -h $db_host -P $db_port -u $db_user -p$db_pass --no-create-info --skip-triggers $current_db         > $output_directory/$current_db"_DATA.sql"
done
zip -r $output_directory".zip" $output_directory
rm -rf $output_directory
