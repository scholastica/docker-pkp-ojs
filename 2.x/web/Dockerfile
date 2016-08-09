FROM nuest:pkp-ojs2
MAINTAINER Daniel Nüst <daniel.nuest@uni-muenster.de>

# ARG can be overridden/set in compose file, see ../base/Dockerfile for full list of ARGs

# Configuring OJS: copy template file, make selected directories writeable (defensive ownership changing)
COPY config.TEMPLATE_DOCKER.inc.php config.inc.php
RUN chown www-data:www-data config.inc.php \
    && chmod ug+rw config.inc.php
