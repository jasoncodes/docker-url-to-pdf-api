FROM debian:buster-slim

ENV LANG C.UTF-8

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    lsb-release ca-certificates curl gnupg git libcap2-bin && \
  echo "deb https://deb.nodesource.com/node_12.x $(lsb_release -cs) main" > /etc/apt/sources.list.d/nodesource.list && \
  curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn apt-key add - && \
  sed 's/ main/ contrib/' < /etc/apt/sources.list > /etc/apt/sources.list.d/contrib.list && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    nodejs chromium\
    fonts-freefont-ttf ttf-mscorefonts-installer fonts-freefont-ttf fonts-liberation2 fonts-roboto && \
  apt --purge remove -y chromium && \
  setcap CAP_NET_BIND_SERVICE=+eip /usr/bin/node && \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

RUN git clone https://github.com/alvarcarto/url-to-pdf-api.git /opt/url-to-pdf-api
RUN cd /opt/url-to-pdf-api && npm install

VOLUME /usr/share/fonts/custom

RUN useradd -m user
USER user

ENV NODE_ENV production
ENV ALLOW_HTTP true
ENV PORT 80

EXPOSE 80
WORKDIR /opt/url-to-pdf-api
CMD ["node", "src/index.js"]
