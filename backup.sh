#!/bin/bash
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
BACKUP_DIR="/home/ubuntu/moodle-docker/backups"
mkdir -p $BACKUP_DIR

sudo docker exec moodle-db /usr/bin/mysqldump -u root --password=rootpass moodle > $BACKUP_DIR/db-$TIMESTAMP.sql

tar -czf $BACKUP_DIR/moodle-code-$TIMESTAMP.tar.gz -C /home/ubuntu/moodle-docker moodle
tar -czf $BACKUP_DIR/moodledata-$TIMESTAMP.tar.gz -C /home/ubuntu/moodle-docker moodledata

echo "Backup completed at $TIMESTAMP"
