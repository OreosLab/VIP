#!/bin/bash

docker exec -it qinglong /bin/sh -c "cd /ql/config
curl -sL https://git.io/config.sh > /ql/config/config.sample.sh
cd /ql/sample && rm config.sample.sh
cp -rf /ql/config/config.sample.sh /ql/sample"

echo $(TZ=UTC-8 date +%Y-%m-%d" "%H:%M:%S)