#!/bin/bash

# 定义颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[1;35m'
NC='\033[0m' # 无颜色

# 检查参数数量
if [ "$#" -ne 8 ]; then
    echo -e "${RED}用法: $0 节点id 节点类型 对接域名 对接密钥 上报阈值 是否开启审计 是否优化连接配置 解锁项目${NC}"
    exit 1
fi

# 读取参数
NODE_ID=$1
NODE_TYPE=$2
API_HOST=$3
API_KEY=$4
REPORT_THRESHOLD=$5
AUDIT_ENABLED=$6
OPTIMIZE_CONNECTION=$7
UNLOCK_SERVICES=$8

# 保存最近一次的参数到文件
PARAM_FILE="/etc/xrayr/last_params.txt"

# 将参数写入文件  仅保存最近一次
echo "NODE_ID=$NODE_ID" > "$PARAM_FILE"
echo "NODE_TYPE=$NODE_TYPE" >> "$PARAM_FILE"
echo "UNLOCK_SERVICES=$UNLOCK_SERVICES" >> "$PARAM_FILE"

echo "最近一次的参数已保存到 /etc/xrayr/last_params.txt 中，可查看最近一次的配置项"

# 备份原文件
echo -e "${BLUE}备份原配置文件...${NC}"
cp /etc/XrayR/config.yml /etc/XrayR/config.yml.bak

# 更新 config.yml 文件内容
echo -e "${BLUE}更新 config.yml 文件内容...${NC}"
cat <<EOL > /etc/XrayR/config.yml
Log:
  Level: warning # Log level: none, error, warning, info, debug
  AccessPath: # /etc/XrayR/access.Log
  ErrorPath: # /etc/XrayR/error.log
DnsConfigPath: # /etc/XrayR/dns.json # Path to dns config, check https://xtls.github.io/config/dns.html for help
RouteConfigPath: /etc/XrayR/route.json # Path to route config, check https://xtls.github.io/config/routing.html for help
InboundConfigPath: # /etc/XrayR/custom_inbound.json # Path to custom inbound config, check https://xtls.github.io/config/inbound.html for help
OutboundConfigPath: /etc/XrayR/custom_outbound.json # Path to custom outbound config, check https://xtls.github.io/config/outbound.html for help
ConnectionConfig:
  Handshake: 4 # Handshake time limit, Second
  ConnIdle: 30 # Connection idle time limit, Second
  UplinkOnly: 2 # Time limit when the connection downstream is closed, Second
  DownlinkOnly: 4 # Time limit when the connection is closed after the uplink is closed, Second
  BufferSize: 64 # The internal cache size of each connection, kB
Nodes:
  - PanelType: "NewV2board" # Panel type: SSpanel, NewV2board, PMpanel, Proxypanel, V2RaySocks, GoV2Panel
    ApiConfig:
      ApiHost: "$API_HOST"
      ApiKey: "$API_KEY"
      NodeID: $NODE_ID
      NodeType: "$NODE_TYPE"  # Node type: V2ray, Vmess, Vless, Shadowsocks, Trojan, Shadowsocks-Plugin
      Timeout: 30 # Timeout for the api request
      EnableVless: true # Enable Vless for V2ray Type
      SpeedLimit: 0 # Mbps, Local settings will replace remote settings, 0 means disable
      DeviceLimit: 0 # Local settings will replace remote settings, 0 means disable
      RuleListPath: # /etc/XrayR/rulelist Path to local rulelist file
      DisableCustomConfig: false # disable custom config for sspanel
    ControllerConfig:
      ListenIP: 0.0.0.0 # IP address you want to listen
      SendIP: 0.0.0.0 # IP address you want to send package
      UpdatePeriodic: 60 # Time to update the nodeinfo, how many sec.
      DeviceOnlineMinTraffic: $REPORT_THRESHOLD  # V2board面板设备数限制统计阈值，大于此流量时上报设备数在线，单位kB，不填则默认上报
      EnableDNS: false # Use custom DNS config, Please ensure that you set the dns.json well
      DNSType: AsIs # AsIs, UseIP, UseIPv4, UseIPv6, DNS strategy
      EnableProxyProtocol: true # Only works for WebSocket and TCP
      AutoSpeedLimitConfig:
        Limit: 0 # Warned speed. Set to 0 to disable AutoSpeedLimit (mbps)
        WarnTimes: 0 # After (WarnTimes) consecutive warnings, the user will be limited. Set to 0 to punish overspeed user immediately.
        LimitSpeed: 0 # The speedlimit of a limited user (unit: mbps)
        LimitDuration: 0 # How many minutes will the limiting last (unit: minute)
      GlobalDeviceLimitConfig:
        Enable: false # Enable the global device limit of a user
        RedisNetwork: tcp # Redis protocol, tcp or unix
        RedisAddr: 127.0.0.1:6379 # Redis server address, or unix socket path
        RedisUsername: # Redis username
        RedisPassword: YOUR PASSWORD # Redis password
        RedisDB: 0 # Redis DB
        Timeout: 5 # Timeout for redis request
        Expiry: 60 # Expiry time (second)
      EnableFallback: false # Only support for Trojan and Vless
      FallBackConfigs:  # Support multiple fallbacks
        - SNI: # TLS SNI(Server Name Indication), Empty for any
          Alpn: # Alpn, Empty for any
          Path: # HTTP PATH, Empty for any
          Dest: 80 # Required, Destination of fallback, check https://xtls.github.io/config/features/fallback.html for details.
          ProxyProtocolVer: 0 # Send PROXY protocol version, 0 for disable
      EnableREALITY: false # 是否开启 REALITY
      DisableLocalREALITYConfig: false  # 是否忽略本地 REALITY 配置
      REALITYConfigs: # 本地 REALITY 配置
        Show: false # Show REALITY debug
        Dest: m.media-amazon.com:443 # REALITY 目标地址
        ProxyProtocolVer: 0 # Send PROXY protocol version, 0 for disable
        ServerNames: # Required, list of available serverNames for the client, * wildcard is not supported at the moment.
          - m.media-amazon.com
        PrivateKey: # 可不填
        MinClientVer: # Optional, minimum version of Xray client, format is x.y.z.
        MaxClientVer: # Optional, maximum version of Xray client, format is x.y.z.
        MaxTimeDiff: 0 # Optional, maximum allowed time difference, unit is in milliseconds.
        ShortIds: # 可不填
          - ""
      CertConfig:
        CertMode: none # Option about how to get certificate: none, file, http, tls, dns. Choose "none" will forcedly disable the tls config.
        CertDomain: "node1.test.com" # Domain to cert
        CertFile: /etc/XrayR/cert/node1.test.com.cert # Provided if the CertMode is file
        KeyFile: /etc/XrayR/cert/node1.test.com.key
        Provider: alidns # DNS cert provider, Get the full support list here: https://go-acme.github.io/lego/dns/
        Email: test@me.com
        DNSEnv: # DNS ENV option used by DNS provider
          ALICLOUD_ACCESS_KEY: aaa
          ALICLOUD_SECRET_KEY: bbb
EOL

# 根据审计和优化连接配置的选项进行替换
if [ "$AUDIT_ENABLED" == "y" ]; then
    echo -e "${YELLOW}启用审计，更新配置...${NC}"
    sed -i "s|^RouteConfigPath: .*|RouteConfigPath: /etc/XrayR/route.json # Path to route config, check https://xtls.github.io/config/routing.html for help|" /etc/XrayR/config.yml
    sed -i "s|^OutboundConfigPath: .*|OutboundConfigPath: /etc/XrayR/custom_outbound.json # Path to custom outbound config, check https://xtls.github.io/config/outbound.html for help|" /etc/XrayR/config.yml
else
    echo -e "${YELLOW}未启用审计，更新配置...${NC}"
    sed -i "s|^RouteConfigPath: .*|RouteConfigPath: # /etc/XrayR/route.json # Path to route config, check https://xtls.github.io/config/routing.html for help|" /etc/XrayR/config.yml
    sed -i "s|^OutboundConfigPath: .*|OutboundConfigPath: # /etc/XrayR/custom_outbound.json # Path to custom outbound config, check https://xtls.github.io/config/outbound.html for help|" /etc/XrayR/config.yml
fi

if [ "$OPTIMIZE_CONNECTION" == "y" ]; then
    echo -e "${YELLOW}启用连接优化，更新配置...${NC}"
    sed -i "/^ConnectionConfig:/,/^Nodes:/ {
        s|^ConnectionConfig:.*|ConnectionConfig:|; 
        s|^  Handshake:.*|  Handshake: 8 # Handshake time limit, Second|; 
        s|^  ConnIdle:.*|  ConnIdle: 10 # Connection idle time limit, Second|; 
        s|^  UplinkOnly:.*|  UplinkOnly: 4  # Time limit when the connection downstream is closed, Second|; 
        s|^  DownlinkOnly:.*|  DownlinkOnly: 4 # Time limit when the connection is closed after the uplink is closed, Second|; 
        s|^  BufferSize:.*|  BufferSize: 64 # The internal cache size of each connection, kB|; 
    }" /etc/XrayR/config.yml
else
    echo -e "${YELLOW}未启用优化连接配置${NC}"
fi

echo -e "${BLUE}备份原 custom_outbound.json...${NC}"
cp /etc/XrayR/custom_outbound.json /etc/XrayR/custom_outbound.json.bak

# 处理解锁项目并生成 custom_outbound.json
echo -e "${BLUE}更新 custom_outbound.json 文件...${NC}"
cat <<EOL > /etc/XrayR/custom_outbound.json
[
  {
    "tag": "IPv4_out",
    "sendThrough": "0.0.0.0",
    "protocol": "freedom"
  }
EOL

# 从 config.yml 中提取解锁项目并生成相应的 outbound 配置
while IFS= read -r line; do
    if [[ $line =~ ^[[:space:]]*-\ [[:space:]]*name:[[:space:]]*(.*) ]]; then
        name=$(echo "${BASH_REMATCH[1]}" | tr -d '\"')  # 去掉引号
    fi
    if [[ $line =~ ^[[:space:]]*password:[[:space:]]*(.*) ]]; then
        uuid=$(echo "${BASH_REMATCH[1]}" | tr -d '\"')  # 去掉引号
    fi
    if [[ $line =~ ^[[:space:]]*address:[[:space:]]*(.*) ]]; then
        address=$(echo "${BASH_REMATCH[1]}" | tr -d '\"')  # 去掉引号
    fi
    if [[ $line =~ ^[[:space:]]*outbound_port:[[:space:]]*(.*) ]]; then
        port=$(echo "${BASH_REMATCH[1]}")  # 直接使用
        # 生成 JSON 配置
        cat <<EOL >> /etc/XrayR/custom_outbound.json
  ,
  {
    "protocol": "Shadowsocks",
    "settings": {
      "servers": [
        {
          "address": "$address",
          "port": $port,
          "method": "chacha20-ietf-poly1305",
          "password": "$uuid"
        }
      ]
    },
    "tag": "unlock-$name"
  }
EOL
    fi
done < /etc/xrayr-onecheck/config.yml

# 结束 JSON 文件
echo "]" >> /etc/XrayR/custom_outbound.json

# 获取 VPS 的 IP 地址和地区
VPS_IP=$(curl -s -4 ifconfig.me)  # 强制获取 IPv4 地址
REGION=$(curl -s ipinfo.io/$VPS_IP | jq -r '.country')

echo -e "${GREEN}本机ip为${MAGENTA} $VPS_IP${NC}"
echo -e "${GREEN}地区为${MAGENTA} $REGION${NC}"

echo -e "${BLUE}备份原 route.json...${NC}"
cp /etc/XrayR/route.json /etc/XrayR/route.json.bak

# 生成 route.json 文件
echo -e "${BLUE}更新 route.json 文件...${NC}"
cat <<EOL > /etc/XrayR/route.json
{
  "domainStrategy": "IPOnDemand",
  "rules": [
    {
      "type": "field",
      "outboundTag": "block",
      "protocol": [
        "bittorrent"
      ]
    }
EOL

# 从 custom_route_templates.json 中读取域名
declare -A service_domains

# 读取 JSON 文件并填充域名
while IFS= read -r line; do
    service_name=$(echo "$line" | jq -r 'keys[0]')
    domains=$(echo "$line" | jq -r '.[] | .domain[]')
    service_domains["$service_name"]="$domains"
done < <(jq -c 'to_entries[] | {(.key): .value}' /etc/xrayr-onecheck/templates/custom_route_templates.json)

# 打印所有可用的解锁项目
echo -e "${YELLOW}可用的解锁项目:${GREEN} ${!service_domains[@]}${NC}"

# 根据解锁项目生成路由规则
IFS=',' read -r -a services <<< "$UNLOCK_SERVICES"
for service in "${services[@]}"; do
    service=$(echo "$service" | xargs)  # 去掉前后空格
    echo -e "${BLUE}处理解锁项目:${YELLOW} $service${NC}"  # 打印当前处理的项目

    # 标志，表示是否已经为该服务生成了路由规则
    service_handled=false

    # 读取 config.yml 文件并检查 streaming_service
    while IFS= read -r line; do
        if [[ $line =~ ^[[:space:]]*-\ [[:space:]]*name:[[:space:]]*(.*) ]]; then
            current_name="${BASH_REMATCH[1]}"
            current_name="${current_name//\"/}"  # 去掉引号
        fi
        if [[ $line =~ ^[[:space:]]*streaming_service:[[:space:]]*(.*) ]]; then
            services_list="${BASH_REMATCH[1]}"
            services_list="${services_list//\"/}"  # 去掉引号

            # 优先检查当前地区
            if [[ $services_list == *"$service"* && "$REGION" == *"$current_name"* && "$service_handled" == false ]]; then
                OUTBOUND_TAG="unlock-$current_name"  # 使用 unlock- 加上匹配的节点名称
                
                cat <<EOL >> /etc/XrayR/route.json
    ,
    {
      "type": "field",
      "outboundTag": "$OUTBOUND_TAG",
      "domain": [
EOL
                # 从 service_domains 中获取域名
                if [[ -n "${service_domains[$service]}" ]]; then
                    domains=${service_domains[$service]}
                    for domain in $domains; do
                        echo "        \"domain:$domain\"," >> /etc/XrayR/route.json
                    done
                else
                    echo -e "${RED}未找到服务 $service 的域名，跳过。${NC}"
                fi

                # 移除最后一个逗号
                sed -i '$ s/,$//' /etc/XrayR/route.json
                cat <<EOL >> /etc/XrayR/route.json
      ]
    }
EOL

                # 设置标志为 true，表示已经处理过该服务
                service_handled=true
                break  # 找到匹配后跳出循环
            fi
        fi
    done < /etc/xrayr-onecheck/config.yml

    # 如果当前地区无法解锁，则检查其他地区
    if [[ "$service_handled" == false ]]; then
        # 重新读取 config.yml 文件并检查其他地区
        while IFS= read -r line; do
            if [[ $line =~ ^[[:space:]]*-\ [[:space:]]*name:[[:space:]]*(.*) ]]; then
                current_name="${BASH_REMATCH[1]}"
                current_name="${current_name//\"/}"  # 去掉引号
            fi
            if [[ $line =~ ^[[:space:]]*streaming_service:[[:space:]]*(.*) ]]; then
                services_list="${BASH_REMATCH[1]}"
                services_list="${services_list//\"/}"  # 去掉引号

                # 检查解锁项目是否在 streaming_service 中
                if [[ $services_list == *"$service"* && "$service_handled" == false ]]; then
                    OUTBOUND_TAG="unlock-$current_name"  # 使用 unlock- 加上匹配的节点名称
                    
                    cat <<EOL >> /etc/XrayR/route.json
    ,
    {
      "type": "field",
      "outboundTag": "$OUTBOUND_TAG",
      "domain": [
EOL
                    # 从 service_domains 中获取域名
                    if [[ -n "${service_domains[$service]}" ]]; then
                        domains=${service_domains[$service]}
                        for domain in $domains; do
                            echo "        \"domain:$domain\"," >> /etc/XrayR/route.json
                        done
                    else
                        echo -e "${RED}未找到服务 $service 的域名，跳过。${NC}"
                    fi

                    # 移除最后一个逗号
                    sed -i '$ s/,$//' /etc/XrayR/route.json
                    cat <<EOL >> /etc/XrayR/route.json
      ]
    }
EOL

                    # 设置标志为 true，表示已经处理过该服务
                    service_handled=true
                    break  # 找到匹配后跳出循环
                fi
            fi
        done < /etc/xrayr-onecheck/config.yml
    fi
done

# 结束 JSON 文件
cat <<EOL >> /etc/XrayR/route.json
  ]
}
EOL

# 输出结果
echo -e "${GREEN}已更新 config.yml、custom_outbound.json 和 route.json 文件${NC}"

echo -e "${BLUE}重启XrayR...${NC}"
systemctl restart XrayR
# 等待5秒
sleep 5
# 检查 XrayR 是否运行
if systemctl is-active --quiet XrayR; then
  echo -e "${GREEN}XrayR重启成功${NC}"
else
  echo -e "${RED}XrayR重启失败 请检查配置{NC}"
fi

echo -e "${YELLOW}脚本执行完成！${NC}"

