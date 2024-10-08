FROM debian:12-slim

RUN apt update && \
apt install -y apache2 && \
apt clean && \
apt autoclean && \
apt autoremove -y && \
rm -rf /var/lib/apt/lists/*

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

COPY index.html /var/www/html/

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]