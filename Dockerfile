FROM alpine:3.3
  ENV HUGO_VERSION 0.15
  ENV HUGO_BINARY hugo_${HUGO_VERSION}_linux_amd64

  RUN apk add --update git
  RUN apk add nginx 
  RUN apk add py-pygments && rm -rf /var/cache/apk/*
  ADD https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY}.tar.gz /usr/local/
  RUN tar xzf /usr/local/${HUGO_BINARY}.tar.gz -C /usr/local/ \
        && echo 'Decompactado...' && ln -s /usr/local/${HUGO_BINARY}/${HUGO_BINARY} /usr/local/bin/hugo \
        && echo 'Criado link...' && rm /usr/local/${HUGO_BINARY}.tar.gz

  RUN mkdir -p /var/www

  RUN /usr/bin/git clone https://github.com/bemanuel/myblog.git /var/www/blog
  #RUN /usr/bin/git clone https://github.com/jpescador/hugo-future-imperfect.git /var/www/blog/themes/hugo-future-imperfect
  

  WORKDIR /var/www/blog
  EXPOSE 80 
  CMD /usr/local/bin/hugo server --bind 0.0.0.0 -p 80 -b="http://blog.bemanuel.com.br" --disableLiveReload=true

