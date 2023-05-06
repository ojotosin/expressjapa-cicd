#!/bin/bash

# Run the docker build command
docker build \
--build-arg PERSONAL_ACCESS_TOKEN='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' \
--build-arg GITHUB_USERNAME='ojotosin' \
--build-arg REPOSITORY_NAME='webfiles'  \
--build-arg WEB_FILE_ZIP='expressjapa.zip' \
--build-arg WEB_FILE_UNZIP='expressjapa' \
--build-arg RDS_ENDPOINT='mysql-service' \
--build-arg RDS_DB_NAME='expressjapa_appdb' \
--build-arg RDS_MASTER_USERNAME='mysqluser' \
--build-arg RDS_DB_PASSWORD='mysqlpassword' \
-t expressjapa .    # tag name