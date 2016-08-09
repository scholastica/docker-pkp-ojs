FROM php:5.6-apache
# https://raw.githubusercontent.com/docker-library/php/master/5.6/apache/Dockerfile
MAINTAINER Daniel Nüst <daniel.nuest@uni-muenster.de>
# See also https://github.com/pkp/ojs-vagrant/tree/master/scripts

# PHP Dependencies, see also https://github.com/docker-library/php/blob/master/docker-php-ext-install
RUN apt-get update -qq \
	&& apt-get install -y --no-install-recommends \
    zlib1g-dev \
    libxml2-dev \
    cron \
    && docker-php-ext-install \
    mysqli \
    mysql \
    zip \
    soap \
    mbstring

# enable mod_rewrite
RUN a2enmod rewrite

# workdir already set in https://raw.githubusercontent.com/docker-library/php/master/5.6/apache/Dockerfile but leave here for readability
WORKDIR /var/www/html
# can be overridden/set in compose file
ARG OJS_URL_VERSION="2.4.8-1"
ARG OJS_PATH="ojs"
ARG OJS_URL_DOWNLOAD="true"
ARG OJS_GIT_URL="NA"
ARG OJS_GIT_TAG="NA"
ARG OJS_SVN_URL="NA"
ARG OJS_SVN_USER="NA"
ARG OJS_SVN_PASS="NA"
ARG OJS_VCS_CLEANUP="true"

# Handle the different download variants in a bash script
COPY ojs-download.sh /ojs-download.sh
RUN /bin/bash /ojs-download.sh

WORKDIR /var/www/html/${OJS_PATH}
RUN echo "Installed OJS to path" $(pwd)

# Configuring OJS: copy template file, make selected directories writeable (defensive ownership changing)
#COPY config.TEMPLATE_DOCKER.inc.php config.inc.php
#RUN chown www-data:www-data config.inc.php \
    #&& chmod ug+rw config.inc.php \
RUN chown -R www-data:www-data public \
    && mkdir cache \
    && chown -R www-data:www-data cache \
    && chmod -R ug+w cache public

# Add crontab running runSheduledTasks.php
COPY ojs-crontab.conf /ojs-crontab.conf
RUN sed -i 's:INSTALL_DIR:'`pwd`':' /ojs-crontab.conf \
    && sed -i 's:FILES_DIR:/var/ojs/files:' /ojs-crontab.conf \
    && echo "$(cat /ojs-crontab.conf)" \
    # Use the crontab file
    && crontab /ojs-crontab.conf \
    && touch /var/log/cron.log

# Add startup script to the container.
COPY ojs-startup.sh /ojs-startup.sh
# Execute the containers startup script which will start many processes/services
CMD ["/bin/bash", "/ojs-startup.sh"]
