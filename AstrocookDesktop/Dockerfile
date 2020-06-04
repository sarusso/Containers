FROM sarusso/basicmetadesktop:v0.2.0
MAINTAINER Stefano Alberto Russo <stefano.russo@gmail.com>

# Switch to root user
USER root

# Install APT dependencies
RUN apt-get install -y python3 python3-pip python3-wxgtk4.0 python3-wxgtk-webview4.0 python3-wxgtk-media4.0

# Install PIP dependencies
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


# Switch back to metauser user
USER metauser

# Add Astrocook code (as metauser)
#RUN cd /home/metauser_vanilla
#COPY ./ /metauser/astrocook

# Clone Astrocook repo (without strict host key checking)
RUN cd /metauser_home_vanilla && GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" git clone https://github.com/DAS-OATs/astrocook.git
RUN cd /metauser_home_vanilla/astrocook && git pull && git checkout 303a7fbbaa6de328cc33be439709b7901790902f

#echo -e "\nStarting Astrocook...\n" > /var/log/astrocook.log
#cd /data && python3 -u /metauser/astrocook/ac_gui.py &>> /var/log/astrocook.log &
#xterm -title "Log" -e "tail -n 1000 -f /var/log/astrocook.log" &
COPY Astrocook.desktop /metauser_home_vanilla/Desktop/

