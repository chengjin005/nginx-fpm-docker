FROM amazonlinux
LABEL maintainer="kane<kane@xiuyan.info>"

ENV fpm_conf /etc/php-fpm.d/www.conf
ENV php_vars /etc/php.ini


RUN yum -y update \
    && amazon-linux-extras install nginx1 php7.1 \
    && yum install -y \
         php-gd \
         php-mbstring \
         php-mcrypt \
         php-pecl-memcached \
         php-soap \
         php-xml \
         php-opcache \
         php-intl \
         php-pecl-zip \
         php-process \
         php-pecl-imagick \
         python-setuptools \
         crontabs \
         procps \
     && easy_install supervisor \
     && yum clean all

ADD conf/supervisord.conf /etc/supervisord.conf

RUN rm -Rf /etc/nginx/nginx.conf && \
    mkdir -p /etc/nginx/sites-available/ && \
    mkdir -p /etc/nginx/sites-enabled/ && \
    mkdir -p /etc/nginx/ssl/ && \
    rm -Rf /var/www/* && \
    mkdir -p /var/www/html/
ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/nginx-site.conf /etc/nginx/sites-available/default.conf
ADD conf/nginx-site-ssl.conf /etc/nginx/sites-available/default-ssl.conf


RUN ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf


RUN  sed -i \
     -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" \
     -e "s/upload_max_filesize = 2M/upload_max_filesize = 100M/g" \
     -e "s/post_max_size = 8M/post_max_size = 100M/g" \
     -e "s/variables_order = \"GPCS\"/variables_order = \"EGPCS\"/g" \
      ${php_vars} && \
      sed -i \
        -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" \
        -e "s/pm.max_children = 50/pm.max_children = 4/g" \
        -e "s/pm.start_servers = 5/pm.start_servers = 3/g" \
        -e "s/pm.min_spare_servers = 5/pm.min_spare_servers = 2/g" \
        -e "s/pm.max_spare_servers = 35/pm.max_spare_servers = 4/g" \
        -e "s/;pm.max_requests = 500/pm.max_requests = 200/g" \
        -e "s/user = apache/user = nginx/g" \
        -e "s/group = apache/group = nginx/g" \
        -e "s/;listen.mode = 0660/listen.mode = 0666/g" \
        -e "s/;listen.owner = nobody/listen.owner = nginx/g" \
        -e "s/;listen.group = nobody/listen.group = nginx/g" \
        -e "s/^;clear_env = no$/clear_env = no/" \
        ${fpm_conf}

# copy in code
ADD src/ /var/www/html/
ADD errors/ /var/www/errors/
EXPOSE 443 80
WORKDIR "/var/www/html"
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
