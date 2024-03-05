#!/bin/sh

CUR_DATE=$(date +"%Y-%m-%d-%H%M-%s")

DB_USER=#<db-user>
DB_PASSWORD=#<db-password>
DB_NAME=#<db-name>
DB_HOST=#<db-host>
DIRECTORY=#<directory-for-temp-file>

DB_FILENAME=${DB_NAME}_${CUR_DATE}.gz
DB_DUMP_PATH=${DIRECTORY}${DB_FILENAME}

# if you want deleting old dumps then only uncomment
# rm ${DIRECTORY}${DB_NAME}_*.gz

PGPASSWORD=$DB_PASSWORD pg_dump -U $DB_USER -h $DB_HOST $DB_NAME | gzip > $DB_DUMP_PATH

# then you may use this archive for a database created from template0:
# gunzip -c </path-to-file/filename>.gz | psql <database-name>


#  if you want send to s3-storage
#  then load s3cmd util
#     sudo apt update
#     sudo apt install s3cmd

#  after uncomment and fill
#
# CUR_YEAR=$(date +"%Y")
# CUR_MONTH=$(date +"%m")
#
# AWS_ACCESS_KEY=#<aws_access-key>
# AWS_SECRET=#<aws-secret>
# AWS_HOST=#<aws-host>
# AWS_HOST_BUCKET=#<aws-bucket>
# CONTAINER_NAME=#<container-name>
# PREFIX=#<prefix>
# AWS_PATH=s3://$CONTAINER_NAME/$PREFIX/$CUR_YEAR/$CUR_MONTH/

# s3cmd --host=$AWS_HOST --host-bucket=$AWS_HOST_BUCKET --access_key=$AWS_ACCESS_KEY --secret_key=$AWS_SECRET put $DB_DUMP_PATH $AWS_PATH

# rm $DB_DUMP_PATH
