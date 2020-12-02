ARG image_tag=latest
ARG php_version
FROM elifesciences/journal_cms_composer:${image_tag} AS composer
FROM elifesciences/php_7.1_fpm:${php_version}

ENV PROJECT_FOLDER=/srv/journal-cms
ENV PHP_ENTRYPOINT=web/index.php
WORKDIR ${PROJECT_FOLDER}

COPY --from=composer --chown=elife:elife /app/web/ web/
COPY --from=composer --chown=elife:elife /app/vendor/ vendor/

USER www-data
