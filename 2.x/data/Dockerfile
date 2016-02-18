FROM mysql:5.7
# use mysql image to have the same users (id,gid) as the containers using this data-only container to hande the ownership rights
MAINTAINER Daniel Nüst <daniel.nuest@uni-muenster.de>
# see  http://stackoverflow.com/questions/23544282/what-is-the-best-way-to-manage-permissions-for-docker-shared-volumes

RUN mkdir -p /var/ojs/files  \
    && chown www-data:www-data /var/ojs/files \
    && chmod -R ug+w /var/ojs/files
VOLUME /var/ojs/files
#WORKDIR /var/ojs/files

VOLUME /var/lib/mysql

# override default command from mysql image
CMD ["/bin/echo", "Data-only container for OJS"]
