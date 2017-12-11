FROM centos:centos7

LABEL io.k8s.description="Nginx Webserver" \
      io.k8s.display-name="Nginx" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="webserver,http,nginx"

ENV NEXUS="https://www.sideburns.de/~bobo/tmo"

RUN useradd -u 1001 nginx

RUN yum install epel-release -y && \
    yum update -y  && \
    yum install -y nginx  && \
    yum clean all 

RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
	  ln -sf /dev/stderr /var/log/nginx/error.log && \
    chgrp -R 0 /var/log/nginx && \
    chmod -R g=u /var/log/nginx && \
    chgrp -R 0 /var/lib/nginx && \
    chmod -R g=u /var/lib/nginx

COPY nginx.conf /etc/nginx
COPY application.conf /etc/nginx.conf.d

RUN for i in 1 2; \
      do \
        mkdir -p /srv/www/app${i} && \
        curl -s -o /tmp ${NEXUS}/app${i}.zip && \ 
        unzip /tmp/app${i}.zip -d /srv/www/app${i} ; \
      done

EXPOSE 8080

STOPSIGNAL SIGTERM
USER 1001
CMD ["nginx", "-g", "daemon off;"]

