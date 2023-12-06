FROM ubuntu:18.04

# Updating the packages and installing dependencies.
RUN apt-get update \  
&& apt-get install unzip cron vim curl -y


# Crontab file copied to cron.d directory.
COPY ./files/cronjob /etc/cron.d/container_cronjob

# Script file copied into container.
COPY ./files/init.sh /init.sh

# Giving executable permission to script file.
RUN chmod +x /init.sh

COPY ./files/ddns-updater.sh /
RUN chmod +x /ddns-updater.sh

# Running commands for the startup of a container.
CMD ["/bin/bash", "-c", "/init.sh && chmod 644 /etc/cron.d/container_cronjob && cron && tail -f /var/log/cron.log"]