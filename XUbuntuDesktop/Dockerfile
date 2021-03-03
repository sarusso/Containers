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
# Ubuntu user
#------------------------

# Add group.
RUN groupadd -g 1000 ubuntu

# Add user.
RUN useradd ubuntu -d /home/ubuntu -u 1000 -g 1000 -m -s /bin/bash

# Add metuaser user to sudoers
RUN adduser ubuntu sudo

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
RUN chown ubuntu:ubuntu /usr/local/share/kasmvnc/certs
COPY files/index.html /usr/local/share/kasmvnc/www/

# Other utilities
RUN apt-get install -y net-tools

# X environment setup/startup
RUN apt-get install fluxbox -y
RUN mkdir -p /ubuntu_home_vanilla/.vnc
COPY files/config  /ubuntu_home_vanilla/.vnc
COPY files/xstartup /ubuntu_home_vanilla/.vnc
RUN chmod 755 /ubuntu_home_vanilla/.vnc/xstartup
RUN chown -R ubuntu:ubuntu /ubuntu_home_vanilla/.vnc

# Prepare for logs
RUN mkdir /ubuntu_home_vanilla/.logs && chown ubuntu:ubuntu /ubuntu_home_vanilla/.logs

# Rename ubuntu home folder as a "vanilla" home folder
#RUN mv /home/ubuntu /ubuntu_home_vanilla

# Add fluxbox customisations
COPY files/dot_fluxbox /ubuntu_home_vanilla/.fluxbox
RUN chown -R ubuntu:ubuntu /ubuntu_home_vanilla/.fluxbox
COPY files/background.jpg /usr/share/images/fluxbox/background.jpg



# Give write access to anyone to the home folder so the entrypoint will be able
# to copy over the /home/matauser_vanilla into /home/ubuntu (for Singularity)
RUN chmod 777 /home

# Extra for 18.04
RUN apt-get install net-tools dbus-x11 -y

#----------------------
#    Xfce
#----------------------

RUN apt-get update
RUN apt-get install xfce4 xfce4-terminal mousepad ristretto tumbler firefox -y

# Replace X startup with version that uses Xfce as Window Manager
COPY files/xstartup /opt/tigervnc/
RUN chmod 755 /opt/tigervnc/xstartup

# X startup
COPY files/xstartup /opt/tigervnc/
RUN chmod 755 /opt/tigervnc/xstartup


#----------------------
#    Desktop
#----------------------

# Add some dependencies
RUN apt-get install imwheel zenity x11-xserver-utils -y

# Create the Desktop
RUN mkdir /ubuntu_home_vanilla/Desktop && chown ubuntu:ubuntu /ubuntu_home_vanilla/Desktop

# Add mouse scrolling script
COPY files/set_mouse_scrolling_speed /usr/bin/
COPY files/Set_Mouse_Scrolling_Speed.desktop /ubuntu_home_vanilla/Desktop/
RUN chmod 755 /usr/bin/set_mouse_scrolling_speed

# Add Display Resolution stuff
#COPY add_display_resolution /usr/bin/
#COPY add_display_resolution_gui /usr/bin/
#COPY Set_Display_Resolution.desktop /ubuntu_home_vanilla/Desktop/
#COPY Add_Display_Resolution.desktop /ubuntu_home_vanilla/Desktop/
#RUN chmod 755 /usr/bin/add_display_resolution && chmod 755 /usr/bin/add_display_resolution_gui 

# Correct ownership of Desktop shortcuts
RUN chown -R ubuntu:ubuntu /ubuntu_home_vanilla/Desktop/

# Shorter bash prompt
#RUN echo "PS1=\"\u@XUbuntuDesktop:\W $ \"" >> /ubuntu_home_vanilla/.bashrc


# Default conf (mostly eyecandy)
COPY files/home_ubuntu_.config /ubuntu_home_vanilla/.config
#COPY data/desktop-cf881dd7/ubuntu_home_vanilla/.config /ubuntu_home_vanilla/.config
RUN chown -R ubuntu:ubuntu /ubuntu_home_vanilla/.config

# Disable screensaver
COPY files/dot_xscreensaver /ubuntu_home_vanilla/.xscreensaver
RUN chown ubuntu:ubuntu /ubuntu_home_vanilla/.xscreensaver

# Disable logout dialog
RUN chmod 000 /usr/bin/xfce4-session-logout

# Create Downloads folder. This is "required" for showing proper spacing between icons in the filemanager a bounch 
RUN mkdir /ubuntu_home_vanilla/Downloads && chown ubuntu:ubuntu /ubuntu_home_vanilla/Downloads


#----------------------
#    Extra SW
#----------------------
RUN sudo apt-get install gdebi-core -y
COPY files/software/dropbox_2015.10.28_amd64.deb /root/
RUN gdebi /root/dropbox_2015.10.28_amd64.deb -n
#RUN apt-get install libreoffice gimp -y

# Shell for temrinal
COPY files/runshell.sh /bin/
RUN chmod 755 /bin/runshell.sh

#--------------------------------------
# Jupyter, Eclipse, keybindings etc.
#--------------------------------------

# Download and install Eclipse and Pydev
RUN wget http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/kepler/SR2/eclipse-standard-kepler-SR2-linux-gtk-x86_64.tar.gz
RUN mv download.php* eclipse-standard-kepler-SR2-linux-gtk-x86_64.tar.gz
RUN tar -zxvf eclipse-standard-kepler-SR2-linux-gtk-x86_64.tar.gz
COPY files/PyDev_3.4.1.zip /tmp
RUN cd eclipse/dropins/ && unzip /tmp/PyDev_3.4.1.zip
RUN mv eclipse /opt/
COPY files/eclipse128.png /opt/eclipse/eclipse128.png
COPY files/Eclipse.desktop /ubuntu_home_vanilla/Desktop/
RUN chown -R ubuntu:ubuntu /ubuntu_home_vanilla/Desktop/


# Giveagain, since xfce install "fixed" it)  write access to anyone to the home folder so the entrypoint
# will be able to copy over the /home/matauser_vanilla into /home/ubuntu (for Singularity)
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
USER ubuntu

# To access: expose 8590/tcp and 5900/tcp
ENV CONTAINER_NAME='xubuntudesktop'
