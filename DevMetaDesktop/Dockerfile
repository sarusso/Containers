FROM basicmetadesktop
MAINTAINER Stefano Alberto Russo <stefano.russo@gmail.com>

USER root

# Always start with an apt-get update when extending Reyns images,
# otherwise apt repositories might get outdated (404 not found)
# and building without cache does not re-build Reyns services.
RUN apt-get update

#----------------------
#   Libraries
#----------------------

COPY files/system_deps.sh /root/
COPY files/python_deps.txt /root/
RUN bash /root/system_deps.sh
RUN pip3 install -r /root/python_deps.txt

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
COPY files/Eclipse.desktop /metauser_home_vanilla/Desktop/
RUN chown -R metauser:metauser /metauser_home_vanilla/Desktop/

# Set terminals interrupt shortcut to ctrl-x
#RUN echo "stty intr ^x" >> /metauser_home_vanilla/.bashrc

# Enable Inet for ssh X forwarding
#RUN echo "AddressFamily inet" >> /etc/ssh/sshd_config

# Add Jupiter in supervisord
#COPY supervisord_jupyter.conf /etc/supervisor/conf.d/

ENV CONTAINER_NAME='devmetadesktop'

USER metauser
