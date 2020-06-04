FROM minimalmetadesktop
MAINTAINER Stefano Alberto Russo <stefano.russo@gmail.com>

USER root

# Always start with an apt-get update when extending Reyns images,
# otherwise apt repositories might get outdated (404 not found)
# and building without cache does not re-build Reyns services.
RUN apt-get update


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
RUN mkdir /metauser_home_vanilla/Desktop && chown metauser:metauser /metauser_home_vanilla/Desktop

# Add mouse scrolling script
COPY files/set_mouse_scrolling_speed /usr/bin/
COPY files/Set_Mouse_Scrolling_Speed.desktop /metauser_home_vanilla/Desktop/
RUN chmod 755 /usr/bin/set_mouse_scrolling_speed

# Add Display Resolution stuff
#COPY add_display_resolution /usr/bin/
#COPY add_display_resolution_gui /usr/bin/
#COPY Set_Display_Resolution.desktop /metauser_home_vanilla/Desktop/
#COPY Add_Display_Resolution.desktop /metauser_home_vanilla/Desktop/
#RUN chmod 755 /usr/bin/add_display_resolution && chmod 755 /usr/bin/add_display_resolution_gui 

# Correct ownership of Desktop shortcuts
RUN chown -R metauser:metauser /metauser_home_vanilla/Desktop/

# Shorter bash prompt
#RUN echo "PS1=\"\u@MetaBox:\W $ \"" >> /metauser_home_vanilla/.bashrc


# Default conf (mostly eyecandy)
COPY files/home_metauser_.config /metauser_home_vanilla/.config
#COPY data/desktop-cf881dd7/metauser_home_vanilla/.config /metauser_home_vanilla/.config
RUN chown -R metauser:metauser /metauser_home_vanilla/.config

# Disable screensaver
COPY files/dot_xscreensaver /metauser_home_vanilla/.xscreensaver
RUN chown metauser:metauser /metauser_home_vanilla/.xscreensaver

# Disable logout dialog
RUN chmod 000 /usr/bin/xfce4-session-logout

# Create Downloads folder. This is "required" for showing proper spacing between icons in the filemanager a bounch 
RUN mkdir /metauser_home_vanilla/Downloads && chown metauser:metauser /metauser_home_vanilla/Downloads


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

# Set conatiner name for prompt
ENV CONTAINER_NAME='basicmetadesktop'

# Giveagain, since xfce install "fixed" it)  write access to anyone to the home folder so the entrypoint
# will be able to copy over the /home/matauser_vanilla into /home/metauser (for Singularity)
RUN chmod 777 /home

# Switch back to metauser
USER metauser


