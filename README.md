## nginx-php-fpm-docker

### 介绍
维护一个供生产环境使用的nginx+php-fpm docker 基础包。默认情况下一个月做一次基础维护。

### 环境说明

操作系统: centos7 

nginx: 1.12.2

php:  7.1.33


### 使用说明

1. a>通过Dockerfile创建镜像

   ```
   sudo docker build -t nginx-php-fpm7.1 .
   ```
   b>直接使用hub.docker.com编译好的docker包
   docker pull kanecheng/nginx-php-fpm7.1

2. 启动容器

   ```
   sudo docker run -itd nginx-php-fpm7.1
   ```

   容器启动后可以通过```http://<DOCKER_HOST>```来访问默认页面，使用```docker inspect```来获取IP地址```DOCKER_HOST``` ，通常是172.17.0.2
