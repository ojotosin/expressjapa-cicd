# Use the latest version of the Ubuntu base image
FROM amazonlinux:latest

# Update all installed packages to their latest versions
RUN yum update && yum upgrade -y 

# Install the unzip package, which we will use it to extract the web files from the zip folder
RUN yum install unzip -y

# Install sudo package
RUN yum install -y sudo

# Install wget package, which we will use it to download files from the internet 
RUN yum install -y wget

# Install curl package, which we will use it to download files from the internet 
RUN yum install -y curl

# Install Apache
RUN yum install -y httpd

# Install PHP and various extensions
RUN amazon-linux-extras enable php7.4 && \
  yum clean metadata && \
  yum install -y \
    php \
    php-common \
    php-pear \
    php-cgi \
    php-curl \
    php-mbstring \
    php-gd \
    php-mysqlnd \
    php-gettext \
    php-json \
    php-xml \
    php-json \
    php-fpm \
    php-intl \
    php-pdo \
    php-zip
    
# Enable allow_url_fopen in PHP.ini
RUN sed -i 's/;allow_url_fopen = On/allow_url_fopen = On/' /etc/php/8.1/apache2/php.ini
    
# Download the MySQL repository package
RUN wget https://repo.mysql.com/mysql80-community-release-el7-3.noarch.rpm

# Import the GPG key for the MySQL repository
RUN rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022

# Install the MySQL repository package
RUN yum localinstall mysql80-community-release-el7-3.noarch.rpm -y

# Install the MySQL community server package
RUN yum install mysql-community-server -y

# Change directory to the html directory
WORKDIR /var/www/html

# Install Git
RUN yum install -y git

# Set the build argument directive
ARG PERSONAL_ACCESS_TOKEN
ARG GITHUB_USERNAME
ARG REPOSITORY_NAME
ARG WEB_FILE_ZIP
ARG WEB_FILE_UNZIP
ARG RDS_ENDPOINT
ARG RDS_DB_NAME
ARG RDS_MASTER_USERNAME
ARG RDS_DB_PASSWORD

# Use the build argument to set environment variables 
ENV PERSONAL_ACCESS_TOKEN=$PERSONAL_ACCESS_TOKEN
ENV GITHUB_USERNAME=$GITHUB_USERNAME
ENV REPOSITORY_NAME=$REPOSITORY_NAME
ENV WEB_FILE_ZIP=$WEB_FILE_ZIP
ENV WEB_FILE_UNZIP=$WEB_FILE_UNZIP
ENV RDS_ENDPOINT=$RDS_ENDPOINT
ENV RDS_DB_NAME=$RDS_DB_NAME
ENV RDS_MASTER_USERNAME=$RDS_MASTER_USERNAME
ENV RDS_DB_PASSWORD=$RDS_DB_PASSWORD

# Clone the GitHub repository
RUN git clone https://$PERSONAL_ACCESS_TOKEN@github.com/$GITHUB_USERNAME/$REPOSITORY_NAME.git

# Unzip the zip folder containing the web files
RUN unzip $REPOSITORY_NAME/$WEB_FILE_ZIP -d $REPOSITORY_NAME/

# Copy the web files into the HTML directory
RUN cp -av $REPOSITORY_NAME/$WEB_FILE_UNZIP/. /var/www/html

# Remove the repository we cloned
RUN rm -rf $REPOSITORY_NAME

# Enable the mod_rewrite setting in the httpd.conf file
RUN sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf

# Give full access to the /var/www/html directory
RUN chmod -R 777 /var/www/html

# configuring the database.php file
RUN sed -i "/^	'hostname'/ s/=.*$/=> '$RDS_ENDPOINT',/" ./application/config/database.php
RUN sed -i "/^	'database'/ s/=.*$/=> '$RDS_DB_NAME',/" ./application/config/database.php 
RUN sed -i "/^	'username'/ s/=.*$/=> '$RDS_MASTER_USERNAME',/" ./application/config/database.php
RUN sed -i "/^	'password'/ s/=.*$/=> '$RDS_DB_PASSWORD',/" ./application/config/database.php


# Expose the default Apache and MySQL ports
EXPOSE 80 3306

# Start Apache and MySQL
ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
