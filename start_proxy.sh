#!/bin/sh

MYVOL=$(pwd)/vol

docker stop sdsecproxy >/dev/null 2>&1
cp /dev/null ${MYVOL}/modsec_audit.log
cp /dev/null ${MYVOL}/modsec_debug.log
docker rm sdsecproxy >/dev/null 2>&1

docker run -d \
    --log-driver json-file \
    --log-opt max-size=100k \
    --log-opt max-file=2 \
    -p 80:80 \
    --link ukwww:backend \
    -e BACKEND="backend:80" \
	-v ${MYVOL}/nginx.conf.template:/etc/nginx/nginx.conf.template:ro \
	-v ${MYVOL}/coreruleset:/etc/crs4:ro \
    -v ${MYVOL}/crs-setup.conf:/etc/nginx/crs-setup.conf:ro \
    -v ${MYVOL}/modsecurity.conf:/etc/nginx/modsecurity.conf:ro \
    -v ${MYVOL}/modsec_audit.log:/var/log/modsec_audit.log \
    -v ${MYVOL}/modsec_debug.log:/var/log/modsec_debug.log \
	--name sdsecproxy \
	cssdata/sdsecproxy
