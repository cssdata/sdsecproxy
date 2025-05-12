#!/bin/sh

CRS_VERSION="4.9.0"

if [ ! -d vol/coreruleset ] ; then
    cd vol
    git clone https://github.com/coreruleset/coreruleset.git 
    if [ $? -ne 0 ]; then
        echo "Failed to clone coreruleset repository"
        exit 1
    fi
    cd coreruleset
    git checkout v${CRS_VERSION}
    if [ $? -ne 0 ]; then
        echo "Failed to checkout version ${CRS_VERSION}"
        exit 1
    fi
    cd ../..  
fi



# This script is used to build the project using the provided Dockerfile.
(cd docker && docker build -t cssdata/sdsecproxy:latest .)
