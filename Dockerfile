#https://github.com/ProcessMaker/processmaker
ARG UBUNTU_CONTAINER

FROM ${UBUNTU_CONTAINER} as process_maker_download
ARG PM_VERSION

RUN apt update
RUN apt install -y wget unzip

WORKDIR /tmp
RUN wget https://github.com/ProcessMaker/processmaker/archive/refs/tags/v${PM_VERSION}.zip
RUN unzip v${PM_VERSION}.zip

FROM ${UBUNTU_CONTAINER} as base
ARG PHP_VER
ARG NODE_MAJOR
ARG NODE_MINOR

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ="Europe/London"
ENV PHP_VER=${PHP_VER}

RUN sysctl -w vm.max_map_count=655300

RUN apt update

RUN apt install -y software-properties-common apt-transport-https ca-certificates lsb-release

RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
RUN apt update

RUN apt install -y php${PHP_VER} php${PHP_VER}-cli php${PHP_VER}-fpm php${PHP_VER}-common php${PHP_VER}-mysql php${PHP_VER}-zip php${PHP_VER}-gd php${PHP_VER}-mbstring php${PHP_VER}-curl php${PHP_VER}-dom php${PHP_VER}-xml php${PHP_VER}-bcmath php${PHP_VER}-imagick php${PHP_VER}-sqlite3 php${PHP_VER}-rdkafka php-pear \
nginx vim curl unzip wget supervisor cron mysql-client build-essential gnupg

# Note in PHP version 8 php-json is in the core https://php.watch/versions/8.0/ext-json

#TODO Not 8.1 PHP modules:
# php-pear - Package manager - leaving not sure if it needs to be version spercific

# NODE INSTALL
ENV NODE_VERSION=16.18.1
RUN apt install -y curl
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

#END NODE INSTALL

RUN wget -O composer-setup.php https://getcomposer.org/installer
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN composer self-update

COPY build-files/laravel-cron /etc/cron.d/laravel-cron
RUN chmod 0644 /etc/cron.d/laravel-cron && crontab /etc/cron.d/laravel-cron

ENV DOCKERVERSION=20.10.5
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 \
                 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz

RUN sed -i 's/www-data/root/g' /etc/php/${PHP_VER}/fpm/pool.d/www.conf

COPY build-files/nginx.conf /etc/nginx/nginx.conf
COPY build-files/services.conf /etc/supervisor/conf.d/services.conf

RUN sed -i 's/_SED_WILL_REPLACE_THIS_WITH_PHP_VER_/'"${PHP_VER}"'/' /etc/nginx/nginx.conf

RUN mkdir -p /code/pm4
WORKDIR /code/pm4
EXPOSE 80 443 6001

FROM base
ARG PM_VERSION

RUN rm -rf /code/pm4 && mkdir -p /code/pm4
COPY --from=process_maker_download /tmp/processmaker-${PM_VERSION} /code/pm4

WORKDIR /code/pm4

# RUN composer install --ignore-platform-reqs
RUN composer install
COPY build-files/laravel-echo-server.json .
RUN npm install --unsafe-perm=true && NODE_OPTIONS="--max-old-space-size=2048" npm run prod

COPY build-files/laravel-echo-server.json .
COPY build-files/init.sh .
COPY build-files/config_database.php ./config/database.php
COPY build-files/restore_state.sh .

#COPY routes/api.php ./routes/api.php
#COPY routes/channels.php ./routes/channels.php
#COPY routes/console.php ./routes/console.php
#COPY routes/web.php ./routes/web.php

RUN mkdir /statefiles && echo RJM=RJM >> /statefiles/.env

# service.conf can not use variable PHP version so make shortcuts to files it uses
RUN ln -s /usr/sbin/php-fpm${PHP_VER} /usr/sbin/php-fpm && ln -s /etc/php/${PHP_VER}/fpm/php-fpm.conf /etc/php/php-fpm-live.conf && mkdir -p /run/php

CMD /code/pm4/restore_state.sh && supervisord --nodaemon
