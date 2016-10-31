FROM alpine:3.4
  ENV HUGO_VERSION 0.17
  ENV HUGO_BINARY hugo_${HUGO_VERSION}_Linux-64bit
  ENV BRANCH master

  #RUN apk add --update git py-pygments
  #RUN apk add nginx 
  RUN apk add --update git py-pygments && rm -rf /var/cache/apk/*
  ADD https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY}.tar.gz /usr/local/
  RUN tar xzf /usr/local/${HUGO_BINARY}.tar.gz -C /usr/local/bin hugo_0.17_linux_amd64/hugo_0.17_linux_amd64 && \
        echo 'Decompactado...' && \
        rm /usr/local/${HUGO_BINARY}.tar.gz && \
        mv /usr/local/bin/hugo_0.17_linux_amd64/hugo_0.17_linux_amd64 /usr/local/bin/hugo
	#&& ln -s /usr/local/${HUGO_BINARY}/${HUGO_BINARY} /usr/local/bin/hugo \
  
  RUN rm -rf /var/cache/apk && mkdir -p /var/www

  RUN git clone -b ${BRANCH} https://github.com/bemanuel/myblog.git /var/www/blog

  RUN cd /var/www/blog && \
      git submodule init && \
      git submodule update
  #RUN /usr/bin/git clone https://github.com/jpescador/hugo-future-imperfect.git /var/www/blog/themes/hugo-future-imperfect
  

  WORKDIR /var/www/blog
  EXPOSE 80 
  CMD /usr/local/bin/hugo server --bind 0.0.0.0 -p 80 -b="http://blog.bemanuel.com.br" --disableLiveReload=true

