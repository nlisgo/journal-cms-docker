ARG image_tag=latest
ARG php_version
FROM elifesciences/journal_cms_composer:${image_tag} AS composer
FROM elifesciences/php_7.3_fpm:${php_version}

ENV PROJECT_FOLDER=/srv/journal-cms
ENV PHP_ENTRYPOINT=web/index.php
WORKDIR ${PROJECT_FOLDER}

USER root

RUN apt-get update
RUN apt-get install git zip unzip libpng-dev mysql-client -y --no-install-recommends

RUN pecl install igbinary uploadprogress
RUN docker-php-ext-install gd pdo_mysql
RUN docker-php-ext-enable igbinary uploadprogress
RUN rm -rf /tmp/pear/

COPY --from=composer --chown=elife:elife /app/web/ web/
COPY --from=composer --chown=elife:elife /app/vendor/ vendor/

RUN chmod a+w web/sites/default
RUN cp web/sites/default/default.settings.php web/sites/default/settings.php
RUN chmod a+w web/sites/default/settings.php
