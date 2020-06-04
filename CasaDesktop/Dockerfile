FROM sarusso/basicmetadesktop:v0.2.0
MAINTAINER Stefano Alberto Russo <stefano.russo@gmail.com>

# Switch to root user
USER root

# Install APT dependencies
RUN apt-get install -y python3 python3-pip python3-wxgtk4.0 python3-wxgtk-webview4.0 python3-wxgtk-media4.0

# Install some PIP dependencies
RUN pip3 install astropy==4.0.0 \
                 scipy==1.3.1 \
                 specutils==0.6 \
                 numpy==1.17.3 \
                 lmfit==0.9.14 \
                 cycler==0.10.0 \
                 statsmodels==0.10.1 \
                 matplotlib==3.1.1 \
                 sphinx==2.2.0\
                 tqdm==4.40.1

# Thanks to https://github.com/e-koch/casa-docker/blob/master/casa4.3/Dockerfile
RUN apt-get update && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 libpng-dev libfreetype6 libfreetype6-dev libxi6 libxrandr2 \
    libxfixes3 libxcursor1 libxinerama1 libfontconfig1 libsqlite3-0 libxslt1.1 unzip bsdmainutils \
    libcurl4-openssl-dev libxft2 xorg openbox

RUN wget https://casa.nrao.edu/download/distro/casa-pipeline/release/el7/casa-pipeline-release-5.6.1-8.el7.tar.gz &&\
    mkdir /usr/local/bin/CASA &&\
    mv casa-pipeline-release-5.6.1-8.el7.tar.gz /usr/local/bin/CASA &&\
    cd /usr/local/bin/CASA &&\
    tar zxvf casa-pipeline-release-5.6.1-8.el7.tar.gz

# Add "casa" command & co. to PATH
ENV PATH /usr/local/bin/CASA/casa-pipeline-release-5.6.1-8.el7/bin:$PATH

# Switch back to metauser user
USER metauser

