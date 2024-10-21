#!/bin/bash

# 定义颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # 无颜色

# 检查参数数量
if [ "$#" -ne 9 ]; then
    echo -e "${YELLOW}未传递参数，继续安装。请手动修改 /etc/xrayr-onecheck/config.yml 文件中的 password 项。${NC}"
    echo -e "${YELLOW}然后执行: haha 节点id 节点类型 对接域名 对接密钥 上报阈值 是否开启审计 是否优化连接配置 解锁类型 \"解锁项目---以逗号隔开\"${NC}"
fi

# 获取参数
UUID=$1  # 如果没有传递第一个参数，使用默认值
shift  # 移除第一个参数，后面的参数将被传递给 haha.sh

# 检查并安装 sudo
if ! command -v sudo &> /dev/null; then
    echo -e "${YELLOW}sudo 未安装，正在安装...${NC}"
    if [ -f /etc/debian_version ]; then
        # 对于 Debian 和 Ubuntu
        apt update
        apt install -y sudo
    elif [ -f /etc/redhat-release ]; then
        # 对于 CentOS
        yum install -y sudo
    else
        echo -e "${RED}不支持的操作系统。${NC}"
        exit 1
    fi
fi

# 更新包列表
echo -e "${BLUE}更新包列表...${NC}"
if [ -f /etc/debian_version ]; then
    # 对于 Debian 和 Ubuntu
    sudo apt update
elif [ -f /etc/redhat-release ]; then
    # 对于 CentOS
    sudo yum check-update
else
    echo -e "${RED}不支持的操作系统。${NC}"
    exit 1
fi

# 检查是否安装了 wget
if ! command -v wget &> /dev/null; then
    echo -e "${RED}wget 未安装，正在安装 wget...${NC}"
    if [ -f /etc/debian_version ]; then
        # 对于 Debian 和 Ubuntu
        sudo apt install -y wget
    elif [ -f /etc/redhat-release ]; then
        # 对于 CentOS
        sudo yum install -y wget
    else
        echo -e "${RED}不支持的操作系统。${NC}"
        exit 1
    fi
fi

# 检查是否安装了 XrayR
if ! command -v xrayr &> /dev/null; then
    echo -e "${RED}XrayR 未安装，正在下载并安装 XrayR...${NC}"
    wget -N --progress=bar https://raw.githubusercontent.com/wyx2685/XrayR-release/master/install.sh && bash install.sh
else
    echo -e "${GREEN}XrayR 已安装。${NC}"
fi

# 检查是否安装了 jq
if ! command -v jq &> /dev/null; then
    # 安装 jq
    echo -e "${BLUE}jq未安装，正在安装 jq...${NC}"
    
    if [ -f /etc/debian_version ]; then
        # 对于 Debian 和 Ubuntu
        sudo apt install -y jq
    elif [ -f /etc/redhat-release ]; then
        # 对于 CentOS
        sudo yum install -y jq
    else
        echo -e "${RED}不支持的操作系统。${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}jq 已安装。${NC}"
fi

# 检查是否安装了 curl
if ! command -v curl &> /dev/null; then
    echo -e "${RED}curl 未安装，正在安装 curl...${NC}"
    # 安装 curl
    if [ -f /etc/debian_version ]; then
        # 对于 Debian 和 Ubuntu
        sudo apt install -y curl
    elif [ -f /etc/redhat-release ]; then
        # 对于 CentOS
        sudo yum install -y curl
    else
        echo -e "${RED}不支持的操作系统。${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}curl 已安装。${NC}"
fi

# 创建目录
mkdir -p /etc/xrayr-onecheck

# 下载所需文件
echo -e "${BLUE}下载 haha.sh 到 /etc/xrayr-onecheck...${NC}"
wget -N --progress=bar https://raw.githubusercontent.com/small-haozi/xrayr-up-onecheck/main/haha.sh -O /etc/xrayr-onecheck/haha.sh

echo -e "${BLUE}下载 config.yml 到 /etc/xrayr-onecheck...${NC}"
wget -N --progress=bar https://raw.githubusercontent.com/small-haozi/xrayr-up-onecheck/main/config.yml -O /etc/xrayr-onecheck/config.yml

echo -e "${BLUE}下载 custom_route_templates.json 到 /etc/xrayr-onecheck/templates...${NC}"
mkdir -p /etc/xrayr-onecheck/templates
wget -N --progress=bar https://raw.githubusercontent.com/small-haozi/xrayr-up-onecheck/main/templates/custom_route_templates.json -O /etc/xrayr-onecheck/templates/custom_route_templates.json

# 设置文件权限
chmod +x "/etc/xrayr-onecheck/haha.sh"

# 创建符号链接
echo -e "${BLUE}创建符号链接 haha...${NC}"
ln -s /etc/xrayr-onecheck/haha.sh /usr/local/bin/haha

echo -e "${GREEN}所有依赖项和文件已成功下载！${NC}"

# 执行 haha 并传递参数
if [ "$#" -gt 0 ]; then
    # 替换 config.yml 中的 <解锁项目的uuid>
    echo -e "${BLUE}替换 config.yml 中的 <解锁项目的uuid>...${NC}"
    sed -i "s|<解锁项目的uuid>|$UUID|g" /etc/xrayr-onecheck/config.yml

    echo -e "${BLUE}执行 一键脚本中...${NC}"
    haha "$@"
else
    echo -e "${YELLOW}请手动修改 /etc/xrayr-onecheck/config.yml 文件中的 password 项。${NC}"
    echo -e "${YELLOW}执行: haha 节点id 节点类型 对接域名 对接密钥 上报阈值 是否开启审计 是否优化连接配置 \"解锁项目---以逗号隔开\"${NC}"
    echo -e "--------------------------------------------"
    echo -e ""
    echo -e "${GREEN}示例：haha 1 shadowsocks http://baidu.com woshijiediankey 1000 y y \"Netflix,TikTok\"${NC}"
    echo -e "${GREEN}上面的示例则代表对接id为1的节点 并解锁 奈飞 TK   ${NC}"
    echo -e ""
    echo -e "--------------------------------------------"
fi

# 删除自身
echo -e "${BLUE}正在删除安装脚本...${NC}"
rm -- "$0"
