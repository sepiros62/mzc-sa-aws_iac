#!/bin/bash

DATE_TIME=`date +"%Y/%B/%d"`
HDFS_LOCATION="hdfs:///user/spark/warehouse/"
AWS_S3_BASE_LOCATION="s3://<bucket>/EMR/"
AWS_S3_LOCATION="s3://<bucket>/EMR/$DATE_TIME"

# Uploda HDFS Backups
upload_HDFS_to_S3 (){
    s3-dist-cp --outputCodec=gzip --src=$HDFS_LOCATION --dest=$AWS_S3_LOCATION
}

#Remove Empty/UNwanted folders "_$folder$"
remove_garbade_file (){
    aws s3 rm $AWS_S3_BASE_LOCATION --exclude "*" --include "*$folder$" --recursive
}

upload_HDFS_to_S3
if [ $? -eq 0 ]; then
    #Run remove empty folders
    remove_garbade_file
else
    echo "ERROR on Backup"
fi
