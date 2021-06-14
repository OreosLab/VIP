# Latest orders
``` sh
docker run -dit \
   -v /apt/jd/config:/jd/config \
   -v /apt/jd/log:/jd/log \
   -v /apt/jd/own:/jd/own \
   -v /apt/jd/scripts:/jd/scripts \
   -v /apt/jd/jbot/diy:/jd/jbot/diy \
   -p 5678:5678 \
   -e ENABLE_TTYD=true \
   -e ENABLE_HANGUP=true \
   -e ENABLE_WEB_PANEL=true \
   -e ENABLE_TG_BOT=true \
   --name jd \
   --hostname jd \
   --restart always \
   nevinee/jd:v4-bot
jd_cookie:
    image: echowxsy/jd_cookie
    container_name: jd_cookie
    restart: always
    ports:
      - 6789:6789
    environment:
      - UPDATE_API=http://ip:5678/updateCookie
      - QYWX_KEY=
```
