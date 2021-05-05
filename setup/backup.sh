#!/bin/sh

docker exec mongo sh -c 'mongodump --archive --gzip' > ./backup-`date +%F_%R`.tar.gz
