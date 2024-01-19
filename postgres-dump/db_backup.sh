CUR_DATE=$(date +"%Y-%m-%d")
DB_NAME=#<database-name> ex: my_database
DB_USERNAME=#<user-name> ex: database_owner
DIRECTORY=#<directory-for-backup> ex: /home/user/backup/

DB_FILENAME=${DB_NAME}_${CUR_DATE}.gz
DB_DUMP_PATH=${DIRECTORY}${DB_FILENAME}

# delete old dumps from directory for backup
rm ${DIRECTORY}${DB_NAME}_*.gz 

sudo pg_dump -h localhost -U $DB_USERNAME $DB_NAME | gzip > $DB_DUMP_PATH

echo "create dump"

# then you may use this archive for a database created from template0:
# gunzip -c </path-to-file/filename>.gz | psql <database-name>