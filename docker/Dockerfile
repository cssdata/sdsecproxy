# Stage 1: Build ModSecurity
FROM debian:bullseye as build

# Install dependencies for building ModSecurity
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    libpcre3-dev \
    libpcre2-dev \
    libxml2-dev \
    zlib1g-dev \
    libyajl-dev \
    libgeoip-dev \
    libssl-dev \
    autoconf automake libtool autotools-dev \
    wget && \
    rm -rf /var/lib/apt/lists/*

# Clone and build ModSecurity
RUN git clone --recursive https://github.com/owasp-modsecurity/ModSecurity modsecurity && \
    cd /modsecurity && \
    ./build.sh && \
    ./configure && \
    make && \
    make install

RUN git clone https://github.com/owasp-modsecurity/ModSecurity-nginx modsecurity-nginx

RUN git clone https://github.com/nginx/nginx.git \
    && cd nginx \
    && mkdir -p /usr/lib/nginx/modules \
    && auto/configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --add-module=/modsecurity-nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/run/nginx.pid --lock-path=/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-http_v3_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-cc-opt='-g -O2 -ffile-prefix-map=/home/builder/debuild/nginx-1.28.0/debian/debuild-base/nginx-1.28.0=. -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie' \
    && make -j$(nproc) \
    && make install

# Create required NGINX cache directories

# # Stage 2: Final Image with Debian and NGINX
FROM debian:bullseye

# # Install NGINX and runtime dependencies for ModSecurity
RUN apt-get update && apt-get install -y \
    gettext \
    libpcre3 \
    libxml2 \
    zlib1g \
    libyajl2 \
    libgeoip1 && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/cache/nginx/client_temp && \
    mkdir -p /var/cache/nginx/proxy_temp && \
    mkdir -p /var/cache/nginx/fastcgi_temp && \
    mkdir -p /var/cache/nginx/uwsgi_temp && \
    mkdir -p /var/cache/nginx/scgi_temp && \
    chown -R nobody:nogroup /var/cache/nginx && \
    mkdir -p /var/log/nginx && \
    chown -R nobody:nogroup /var/log/nginx && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    ln -sf /dev/stdout /var/log/nginx/access.log

# Copy ModSecurity binaries and libraries from the build stage
# COPY --from=build /usr/local/modsecurity/bin /usr/local/bin
# COPY --from=build /usr/local/modsecurity/lib /usr/local/lib
COPY --from=build /usr/local/modsecurity /usr/local/modsecurity

# Copy NGINX binary
COPY --from=build /usr/sbin/nginx /usr/sbin/nginx

# Copy NGINX configuration
COPY --from=build /etc/nginx /etc/nginx

# Copy NGINX modules
COPY --from=build /usr/lib/nginx/modules /usr/lib/nginx/modules

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENV BACKEND="http://backend:8080"

# # Expose NGINX port
EXPOSE 80

# NGINX startup script
ENTRYPOINT [ "/start.sh" ]