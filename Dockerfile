FROM  httpd
RUN apt update
WORKDIR /usr/local/apache2/htdocs/
VOLUME /saves
COPY ./app/ .
EXPOSE 80
