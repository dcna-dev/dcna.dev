FROM alpine:latest

ENV HUGO_VERSION 0.53
ENV HUGO_BINARY hugo_${HUGO_VERSION}_Linux-64bit.tar.gz

# Install Hugo
RUN set -x && \
  apk --no-cache add --update wget ca-certificates git && \
  wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} && \
  tar xzf ${HUGO_BINARY} && \
  rm -r ${HUGO_BINARY} && \
  mv hugo /usr/bin && \
  apk del wget
RUN git clone --recursive https://github.com/dcna-io/dcna.io.git /site
WORKDIR /site
RUN /usr/bin/hugo


FROM nginx:alpine

#COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

WORKDIR /var/www/site

COPY --from=0 /site/public /var/www/site 
