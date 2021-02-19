FROM ubuntu:18.04
MAINTAINER Stefano Alberto Russo <stefano.russo@gmail.com>

#----------------------
# Basics
#----------------------

# Set non-interactive
ENV DEBIAN_FRONTEND noninteractive

# Update first of all
RUN apt-get update

# Utilities
RUN apt-get install -y nano telnet unzip wget supervisor build-essential python-dev git-core openjdk-8-jre


#------------------------
# "Meta" user
#------------------------

# Add group. We chose GID 65527 to try avoiding conflicts.
RUN groupadd -g 65527 metauser

# Add user. We chose UID 65527 to try avoiding conflicts.
RUN useradd metauser -d /home/metauser -u 65527 -g 65527 -m -s /bin/bash

# Add metuaser user to sudoers
RUN adduser metauser sudo

# Install suodo
RUN apt-get install sudo -y

# No pass sudo (for everyone, actually)
COPY files/sudoers /etc/sudoers

#------------------------
# Supervisor conf
#------------------------

# Supervisord conf
COPY files/supervisord.conf /etc/supervisor/

#------------------------
# VNC
#------------------------

# Install xvfb that triggers minimal install of X base packages and xterm as sample application
RUN apt-get install xvfb xterm  -y

# Install base packages for VNC server and headless desktop (2)
#RUN cd /opt && wget https://bintray.com/tigervnc/stable/download_file?file_path=tigervnc-1.8.0.x86_64.tar.gz -O tigervnc-1.8.0.x86_64.tar.gz \
#            && tar -zxvf tigervnc-1.8.0.x86_64.tar.gz \
#            && mv tigervnc-1.8.0.x86_64 tigervnc

# Supervisord configuration
COPY files/supervisord_kasm.conf /etc/supervisor/conf.d/
COPY files/run_kasm.sh /etc/supervisor/conf.d/
RUN chmod 755 /etc/supervisor/conf.d/run_kasm.sh

# Kasm VNC (modded by gtaffoni to use a socket named by an env var)
COPY files/kasmvnc-Linux-x86_64-0.9.tar.gz /tmp
RUN sudo tar xz --strip 1 -C / -f /tmp/kasmvnc-Linux-x86_64-0.9.tar.gz && rm /tmp/kasmvnc-Linux-x86_64-0.9.tar.gz
RUN mkdir /usr/local/share/kasmvnc/certs
RUN chown metauser:metauser /usr/local/share/kasmvnc/certs
COPY files/index.html /usr/local/share/kasmvnc/www/

# Other utilities
RUN apt-get install -y net-tools

# X environment setup/startup
RUN apt-get install fluxbox -y
RUN mkdir -p /metauser_home_vanilla/.vnc
COPY files/config  /metauser_home_vanilla/.vnc
COPY files/xstartup /metauser_home_vanilla/.vnc
RUN chmod 755 /metauser_home_vanilla/.vnc/xstartup
RUN chown -R metauser:metauser /metauser_home_vanilla/.vnc

# Prepare for logs
RUN mkdir /metauser_home_vanilla/.logs && chown metauser:metauser /metauser_home_vanilla/.logs

# Rename metauser home folder as a "vanilla" home folder
#RUN mv /home/metauser /metauser_home_vanilla

# Add fluxbox customisations
COPY files/dot_fluxbox /metauser_home_vanilla/.fluxbox
RUN chown -R metauser:metauser /metauser_home_vanilla/.fluxbox
COPY files/background.jpg /usr/share/images/fluxbox/background.jpg



# Give write access to anyone to the home folder so the entrypoint will be able
# to copy over the /home/matauser_vanilla into /home/metauser (for Singularity)
RUN chmod 777 /home


#----------------------
# Entrypoint
#----------------------

# Copy entrypoint
COPY files/entrypoint.sh /

# Give right permissions
RUN chmod 755 /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Set user (mainly for Singularity)
USER metauser

# To access: expose 8590/tcp and 5900/tcp
ENV CONTAINER_NAME='minimalmetadesktop'
