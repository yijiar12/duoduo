FROM node:latest

WORKDIR /home/choreouser

COPY files/* /home/choreouser/

ENV PM2_HOME=/tmp

CMD ["gotty", "-r", "-w", "--port", "8080", "/bin/bash"]

RUN apt-get update &&\
    apt-get install -y iproute2 vim &&\
    npm install -r package.json &&\
    npm install -g pm2 &&\
    wget -O cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb &&\
    dpkg -i cloudflared.deb &&\
    rm -f cloudflared.deb &&\
    addgroup --gid 10001 choreo &&\
    adduser --disabled-password  --no-create-home --uid 10001 --ingroup choreo choreouser &&\
    usermod -aG sudo choreouser &&\
    chmod +x web.js entrypoint.sh nezha-agent ttyd &&\
    npm install -r package.json

ENTRYPOINT [ "node", "server.js" ]

# Use the base image
FROM modenaf360/gotty:latest
 
# Expose the desired port
EXPOSE 8080
 
# Start Gotty with the specified command
CMD ["gotty", "-r", "-w", "--port", "8080", "/bin/bash"]

USER 10001
