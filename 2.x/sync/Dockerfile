FROM debian:jessie
# use same base image as web container (php-apache)
MAINTAINER Daniel Nüst <daniel.nuest@uni-muenster.de>

# based on https://docs.docker.com/engine/examples/running_ssh_service/
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd

# TODO add public key for login

RUN echo "root:pass" | chpasswd
RUN sed -i "s/PermitRootLogin without-password/PermitRootLogin yes/" /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed "s@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g" -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

# Get the port number and IP from "docker network inspect 2x_default"
# Then connect with "ssh root@IP -p PORTNUMBER"
