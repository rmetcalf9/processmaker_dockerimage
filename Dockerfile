FROM ubuntu:20.04 as base
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ="Europe/London"

RUN apt update

# In ubuntu 20.04, installing php without specifying a version installs 7.4 :)
RUN apt install -y php php-cli php-fpm php-json php-common php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath php-imagick php-dom php-sqlite3 \
nginx vim curl unzip wget supervisor cron mysql-client build-essential

#
# node
#
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt -y install nodejs

#
# install composer
#
RUN wget -O composer-setup.php https://getcomposer.org/installer
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN composer self-update

#
# cron
#
COPY build-files/laravel-cron /etc/cron.d/laravel-cron
RUN chmod 0644 /etc/cron.d/laravel-cron && crontab /etc/cron.d/laravel-cron

#
# docker client
#
ENV DOCKERVERSION=20.10.5
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 \
                 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz

#
# configure php-fpm to run as root
#
RUN sed -i 's/www-data/root/g' /etc/php/7.4/fpm/pool.d/www.conf

COPY build-files/nginx.conf /etc/nginx/nginx.conf
COPY build-files/services.conf /etc/supervisor/conf.d/services.conf


RUN mkdir -p /code/pm4
WORKDIR /code/pm4
EXPOSE 80 443 6001

FROM base

ARG PM_VERSION

WORKDIR /tmp
RUN wget https://github.com/ProcessMaker/processmaker/archive/refs/tags/v${PM_VERSION}.zip
RUN unzip v${PM_VERSION}.zip && rm -rf /code/pm4 && mv processmaker-${PM_VERSION} /code/pm4

WORKDIR /code/pm4
RUN composer install
COPY build-files/laravel-echo-server.json .
RUN npm install --unsafe-perm=true && npm run dev

COPY build-files/laravel-echo-server.json .
COPY build-files/init.sh .
COPY build-files/restore_state.sh .

RUN mkdir /statefiles && echo RJM=RJM >> /statefiles/.env

CMD /code/pm4/restore_state.sh && supervisord --nodaemon