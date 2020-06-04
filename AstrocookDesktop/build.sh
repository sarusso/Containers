
#!/bin/bash

if [ ! -f "Dockerfile" ]; then
    # TODO: This check is weak: improve me!
    echo "Please run this script from the AstrocookDesktop folder"
    exit 1
fi

# Use --no-cache in case of build problems (i.e. 404 not found)
docker build . -t astrocookdesktop

