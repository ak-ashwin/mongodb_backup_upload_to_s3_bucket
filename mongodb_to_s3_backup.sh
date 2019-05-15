#!/bin/bash
 
#Force file syncronization and lock writes
# mongo admin --eval "printjson(db.fsyncLock())"
 
# MONGODUMP_PATH="/Users/apple/Downloads/mongo_db_to_s3_backup"
# MONGO_HOST="mongodb://username@password//clusterfree1-shard-00-00-4wab8.mongodb.net" #replace with your server ip
# MONGO_PORT="27017"
# MONGO_DATABASE="test1" #replace with your database name
 
TIMESTAMP=`date +%F-%H%M`
S3_BUCKET_NAME="mongodb-backup-bucket" #replace with your bucket name on Amazon S3
S3_BUCKET_PATH="mongodb-backups"
 

# Create backup
# $MONGODUMP_PATH -h $MONGO_HOST:$MONGO_PORT -d $MONGO_DATABASE
mongodump --host ClusterFree1-shard-0/clusterfree1-shard-00-00-4wab8.mongodb.net:27017,clusterfree1-shard-00-01-4ab8.mongodb.net:27017,clusterfree1-shard-00-02-4wab8.mongodb.net:27017 --ssl --username admin --password password123 --authenticationDatabase admin --db test1

 
# # Add timestamp to backup
# mv dump mongodb-$HOSTNAME-$TIMESTAMP
# tar cf mongodb-$HOSTNAME-$TIMESTAMP.tar mongodb-$HOSTNAME-$TIMESTAMP
zip -r dump-$TIMESTAMP.zip dump
 
# # Upload to S3
s3cmd put dump-$TIMESTAMP.zip s3://$S3_BUCKET_NAME/$S3_BUCKET_PATH/  --access_key=abcde --secret_key=12345
 
# s3cmd  put /Users/apple/Downloads/mongo_db_to_s3_backup/dump-2018-07-19-1035.zip s3://mongodb-backup-bucket/mongodb-backups/  --access_key=abcde --secret_key=12345

# file=/path/to/file/to/upload.tar.gz
# bucket=mongodb-backup-bucket
# resource="/${bucket}/${file}"
# contentType="application/x-compressed-tar"
# dateValue=`date -R`
# stringToSign="PUT\n\n${contentType}\n${dateValue}\n${resource}"
# s3Key=abcde
# s3Secret=12345
# signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${s3Secret} -binary | base64`
# curl -X PUT -T "${file}" \
#   -H "Host: ${bucket}.s3.amazonaws.com" \
#   -H "Date: ${dateValue}" \
#   -H "Content-Type: ${contentType}" \
#   -H "Authorization: AWS ${s3Key}:${signature}" \
#   https://${bucket}.s3.amazonaws.com/${file}


#Unlock database writes
# mongo admin --eval "printjson(db.fsyncUnlock())"


