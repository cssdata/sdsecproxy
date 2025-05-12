# sdsecproxy

A very simple nginx proxy with modsecurity and corerulesets (v4.14.0)

Just look at the start_proxy.sh and change the 2 lines

    --link mywww:backend \
    -e BACKEND="backend:80" \

NOTE: If you don't link-in your backend, BACKEND my point to an external backend also. In this case here, backend and proxy share the same docker network.

This container just exposes port 80 and there is no ssl setup because it is sitting behind another ingres proxy that terminates ssl
