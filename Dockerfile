FROM centos:centos7

LABEL io.k8s.description="Nginx Webserver" \
      io.k8s.display-name="Nginx" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="webserver,http,nginx"

RUN useradd -u 1001 nginx

COPY nginx.repo /etc/yum.repos.d/

RUN yum install -y nginx  && \
    yum clean all 

RUN sed -i -e '/listen/!b' -e '/80;/!b' -e 's/80;/8080;/' /etc/nginx/conf.d/default.conf && \
    sed -i -e '/user/!b' -e '/nginx/!b' -e '/nginx/d' /etc/nginx/nginx.conf && \
    sed -i 's!/var/run/nginx.pid!/var/cache/nginx/nginx.pid!g' /etc/nginx/nginx.conf && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    chgrp -R 0 /var/log/nginx && \
    chmod -R g=u /var/log/nginx && \
    chgrp -R 0 /var/cache/nginx && \
    chmod -R g=u /var/cache/nginx

EXPOSE 8080

STOPSIGNAL SIGTERM
USER 1001
CMD ["nginx", "-g", "daemon off;"]
