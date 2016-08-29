FROM alpine:3.4
  ENV HUGO_VERSION 0.16
  ENV HUGO_BINARY hugo_${HUGO_VERSION}_linux-64bit
  ENV BRANCH 0.8

  RUN apk add --update git
  RUN apk add nginx 
  RUN apk add py-pygments && rm -rf /var/cache/apk/*
  ADD https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY}.tgz /usr/local/
  RUN tar xzf /usr/local/${HUGO_BINARY}.tgz -C /usr/local/bin ./hugo && \
        echo 'Decompactado...' && \
        rm /usr/local/${HUGO_BINARY}.tgz
	#&& ln -s /usr/local/${HUGO_BINARY}/${HUGO_BINARY} /usr/local/bin/hugo \
  
  RUN rm -rf /var/cache/apk

  RUN mkdir -p /var/www

  RUN /usr/bin/git clone -b ${BRANCH} https://github.com/bemanuel/myblog.git /var/www/blog
  RUN cd /var/www/blog && \
      git submodule init && \
      git submodule update
  #RUN /usr/bin/git clone https://github.com/jpescador/hugo-future-imperfect.git /var/www/blog/themes/hugo-future-imperfect
  

  WORKDIR /var/www/blog
  EXPOSE 80 
  CMD /usr/local/bin/hugo server --bind 0.0.0.0 -p 80 -b="http://blog.bemanuel.com.br" --disableLiveReload=true

