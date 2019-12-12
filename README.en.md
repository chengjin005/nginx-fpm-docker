# nginx-php

#### Description
Maintain a nginx-php-fpm docker base package for production environments

#### Environment

Operating system: centos7

nginx: 1.12.2

php:  7.1.33


#### Instructions

1. Create  image 

   ```
   sudo docker build -t nginx-php-fpm .
   ```

2. Run the container

   ```
   sudo docker run -itd nginx-php-fpm
   ```

   You can then browse to ```http://<DOCKER_HOST>``` to view the default install files. To find your ```DOCKER_HOST``` use the ```docker inspect``` to get the IP address (normally 172.17.0.2)