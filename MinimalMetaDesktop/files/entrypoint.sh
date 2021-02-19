#!/bin/bash

 # Exit on any error. More complex thing could be done in future
# (see https://stackoverflow.com/questions/4381618/exit-a-script-on-error)
set -e


if [ "x$SAFE_MODE" == "xTrue" ]; then
    echo ""
    echo "[INFO] Not executing entrypoint as we are in safe mode, just opening a Bash shell."
    exec /bin/bash
else
	echo ""
	echo "[INFO] Executing entrypoint..."
	
	if [ "x$BASE_PORT" == "x" ]; then
	    echo "[INFO] No task base port set, will set noVNC port 8590 and VNC port 5900 with desktop id \"0\""  
	else 
	    echo "[INFO] Task base port set, will set noVNC port $BASE_PORT and noVNC port $(($BASE_PORT+1)) with desktop id \"$(($BASE_PORT-5900+1))\""
	fi
	
    #---------------------
    #   Setup home
    #---------------------

	if [ -f "/home/metauser/.initialized" ]; then
	    :
	else
		echo "[INFO] Setting up home"
		mkdir -p /home/metauser

        # Copy over vanilla home contents
		for x in /metauser_home_vanilla/* /metauser_home_vanilla/.[!.]* /metauser_home_vanilla/..?*; do
            if [ -e "$x" ]; then cp -a "$x" /home/metauser/; fi
        done
		
	# Mark as initialized
	    touch /home/metauser/.initialized
	fi
	
    # Manually set home (mainly for Singularity)
	echo "[INFO] Setting up HOME env var"
	export HOME=/home/metauser
	cd /home/metauser
	
    #---------------------
    #   Save env
    #---------------------
	echo "[INFO] Dumping env"
	
    # Save env vars for later usage (e.g. ssh)
	
	env | \
	while read env_var; do
	  if [[ $env_var == HOME\=* ]]; then
	      : # Skip HOME var
	  elif [[ $env_var == PWD\=* ]]; then
	      : # Skip PWD var
	  else
	      echo "export $env_var" >> /tmp/env.sh
	  fi
	done

	
    #---------------------
    #   Password
    #---------------------

    if [ "x$AUTH_PASS" != "x" ]; then
        echo "[INFO] Setting up VNC password..."
    else
        echo "[INFO] Setting up default VNC password (metapassword)"
        AUTH_PASS=metapass
    fi            
    /usr/local/bin/kasmvncpasswd -f <<< $AUTH_PASS > /home/metauser/.kasmpasswd
    chmod 600 /home/metauser/.kasmpasswd
    export VNC_AUTH=True


    #---------------------
    #   User
    #---------------------

    if [ "x$AUTH_USER" != "x" ]; then
        echo "[INFO] Setting up VNC user..."
        sed -i -e "s/username=metauser/username=$AUTH_USER/" /home/metauser/.vnc/config 
    else
        echo "[INFO] Setting up default VNC user (metauser)"
    fi

							
	echo "[INFO] Setting new prompt @$CONTAINER_NAME container"
	echo 'export PS1="${debian_chroot:+($debian_chroot)}\u@$CONTAINER_NAME@\h:\w\$ "' >> /home/metauser/.bashrc
	
	
	
    #---------------------
    #  Entrypoint command
    #---------------------
	
	if [ "$@x" == "x" ]; then
	    DEFAULT_COMMAND="supervisord -c /etc/supervisor/supervisord.conf"
	    echo -n "[INFO] Executing default entrypoint command: "
	    echo $DEFAULT_COMMAND
	    exec $DEFAULT_COMMAND
	else
	    echo -n "[INFO] Executing entrypoint command: "
	    echo $@
	    exec $@
	fi 

fi

