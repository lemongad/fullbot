#!/bin/bash

gost -L mws://pass@:7860?path=/ws &
cat > /app/resources/config.yaml <<EOF
admin:
  - ${admin}
bot:
 api_id: ${api_id}
 api_hash: ${api_hash}
 bot_token: ${bot_token}
clash:
 path: './bin/fulltclash-${branch}'
 core: ${core}
 startup: ${startup}
 branch: ${branch}
pingurl: https://www.gstatic.com/generate_204
netflixurl: "https://www.netflix.com/title/80113701"
speedfile:
  - https://dl.google.com/dl/android/studio/install/3.4.1.0/android-studio-ide-183.5522156-windows.exe
  - https://dl.google.com/dl/android/studio/install/3.4.1.0/android-studio-ide-183.5522156-windows.exe
speednodes: ${speednodes}
speedthread: ${speedthread}
nospeed: ${nospeed}
speed_end_colors_switch: true
end_colors_switch: true
subconverter: 
 enable: true 
 host: 'back.889876.xyz' 
 tls: true
 remoteconfig: "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online.ini" #远程配置
EOF
python3 main.py
