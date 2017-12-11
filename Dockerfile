FROM centos:centos7

LABEL io.k8s.description="Nginx Webserver" \
      io.k8s.display-name="Nginx" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="webserver,http,nginx"

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

EXPOSE 8080

STOPSIGNAL SIGTERM
USER 1001
CMD ["nginx", "-g", "daemon off;"]
