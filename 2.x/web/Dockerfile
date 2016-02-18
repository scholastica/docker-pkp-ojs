FROM php:5.6-apache
# https://raw.githubusercontent.com/docker-library/php/master/5.6/apache/Dockerfile
MAINTAINER Daniel Nüst <daniel.nuest@uni-muenster.de>
# See also https://github.com/pkp/ojs-vagrant/tree/master/scripts

# PHP Dependencies, see also https://github.com/docker-library/php/blob/master/docker-php-ext-install
RUN apt-get update -qq \
	&& apt-get install -y --no-install-recommends \
    zlib1g-dev \
    libxml2-dev -y \
    && docker-php-ext-install \
    mysqli \
    mysql \
    zip \
    soap

# TODO check if this is added to php image in the future: https://github.com/docker-library/php/issues/34
RUN docker-php-ext-install mbstring

# workdir already set in https://raw.githubusercontent.com/docker-library/php/master/5.6/apache/Dockerfile but leave here for readability
WORKDIR /var/www/html

# can be overridden in compose file
ARG OJS_VERSION=2.4
ARG OJS_PATH=ojs

# Installation instructions for 2.x: https://pkp.sfu.ca/ojs/README
RUN echo "Downloading OJS version ${OJS_VERSION}\n" \
    && curl -sSL -O http://pkp.sfu.ca/ojs/download/ojs-${OJS_VERSION}.tar.gz \
    && tar -zxf ojs-${OJS_VERSION}.tar.gz \
    && mv ojs-${OJS_VERSION} ${OJS_PATH}
# Do patches have to be applied here?

# TODO test as an alternative: check out from source via tag, e.g. https://github.com/pkp/ojs/tree/ojs-stable-2_4_8

WORKDIR /var/www/html/ojs

# Installation instructions for 3.x: https://github.com/pkp/ojs/tree/master/docs
# FOR 3.x only: Install composer Dependencies
#    && cd /var/www/html/lib/pkp \
#    && curl -sS https://getcomposer.org/installer | php \
#    && php composer.phar update \


# TODO add cron task for runSheduledTasks.php

# TODO can I copy or save the config.inc.php to the data volume?

# Configuring OJS: copy template file, make selected directories writeable
COPY config.TEMPLATE_DOCKER.inc.php config.inc.php

# defensive ownership changing:
RUN chown www-data:www-data config.inc.php \
    && chmod ug+rw config.inc.php \
    && chown -R www-data:www-data public \
    && chown -R www-data:www-data cache \
    && chmod -R ug+w cache public
