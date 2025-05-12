#!/bin/sh

# Replace ${BACKEND} in the template with the actual environment variable
envsubst '${BACKEND}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Replace the shell process with NGINX running in the foreground
exec nginx -g 'daemon off;'