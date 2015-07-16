###########################################################
# VikingCo: Kong (http://getkong.org)
###########################################################
FROM debian:jessie
MAINTAINER Dirk Moors

ENV DEPENDENCYDIR /tmp/deps
ENV CONFIGURATIONDIR /tmp/conf
ENV SCRIPTSDIR /tmp/scripts

ENV KONG_GIT_URL https://github.com/Mashape/kong.git
ENV KONG_GIT_BRANCH master

# Set default locale for the environment
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Add dependencies
ADD deps ${DEPENDENCYDIR}

# Temporary step?: https://github.com/Mashape/kong/issues/400#issuecomment-121571326
#RUN set -x \
#    && apt-get update \
#    && apt-get install -y --no-install-recommends sudo wget ca-certificates netcat lua5.1 openssl libpcre3 dnsmasq \
#    && cd /tmp/ \
#    && wget https://github.com/Mashape/kong/releases/download/0.3.2/kong-0.3.2.jessie_all.deb \
#    && dpkg -i kong-0.3.2.*.deb \
#    && rm -rf /etc/kong/

# install and configure packages
# && gpg --keyserver pgpkeys.mit.edu --recv-key A0E98066 \
# && wget http://openresty.org/download/ngx_openresty-1.7.10.2.tar.gz.asc \
# && gpg ngx_openresty-1.7.10.2.tar.gz.asc \
RUN set -x \
	&& buildDeps=`cat ${DEPENDENCYDIR}/builddeps.txt` && echo $buildDeps \
	&& requiredAptPackages=`cat ${DEPENDENCYDIR}/deps.txt` && echo requiredAptPackages \
	&& apt-get update \
	&& apt-get install -y $buildDeps $requiredAptPackages --no-install-recommends \
	&& dpkg-reconfigure locales \
	&& locale-gen C.UTF-8 \
    && /usr/sbin/update-locale LANG=C.UTF-8 \
    && echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen \
    && locale-gen \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /root/.ssh/ \
    && echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config \
    && cd ${DEPENDENCYDIR} \
    && tar xzvf luarocks-2.2.2.tar.gz \
    && cd luarocks-2.2.2 \
    && ./configure \
    && make && make install \
    && cd ${DEPENDENCYDIR} \
    && tar xzvf ngx_openresty-1.7.10.2.tar.gz \
    && cd ngx_openresty-1.7.10.2/ \
    && ./configure \
        --with-pcre-jit \
        --with-ipv6 \
        --with-http_realip_module \
        --with-http_ssl_module \
        --with-http_stub_status_module \
    && make && make install \
    && cd /tmp/ \
    && git clone ${KONG_GIT_URL} --branch ${KONG_GIT_BRANCH} --single-branch --depth=1 \
    && cd kong/ \
    && make install \
	&& apt-get purge -y --auto-remove $buildDeps

# Add config files
ADD conf ${CONFIGURATIONDIR}

# Add scripts
ADD scripts ${SCRIPTSDIR}

# Make kong config dir
RUN mkdir -p /etc/kong/

# Link DNSMasq settings
RUN cd /etc \
   && rm -rf dnsmasq.conf \
   && ln -s ${CONFIGURATIONDIR}/dnsmasq.conf

# Link KONG settings
RUN cd /etc/kong/ \
   && rm -rf kong.yml \
   && ln -s ${CONFIGURATIONDIR}/kong.yml

# expose ports
EXPOSE 8000 8001

# expose run command
CMD ${SCRIPTSDIR}/run.sh
