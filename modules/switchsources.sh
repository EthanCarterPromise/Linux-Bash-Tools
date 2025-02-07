#!/bin/bash

# 检查是否安装了 curl
if ! command -v curl &> /dev/null; then
    echo "curl 未安装，正在更新 apt 并安装 curl..."
    apt update -y && apt install curl -y
else
    echo "curl 已安装，无需操作。"
fi

# 提供用户选择的镜像源
echo "请选择要使用的 Debian 软件源:"
echo "1) 官方源 (deb.debian.org)"
echo "2) 清华大学镜像源 (mirrors.tuna.tsinghua.edu.cn)"
echo "3) 腾讯云镜像源 (mirrors.cloud.tencent.com)"
echo "4) 阿里云镜像源 (mirrors.aliyun.com)"
echo "5) 腾讯云内网镜像源 (mirrors.tencentyun.com)"
echo "6) 阿里云内网镜像源 (mirrors.cloud.aliyuncs.com)"
read -p "输入选项 (1、2、3、4、5 或 6): " choice

if [ "$choice" == "1" ]; then
    SOURCE_URL="deb https://deb.debian.org/debian"
    SECURITY_URL="deb https://deb.debian.org/debian-security"
elif [ "$choice" == "2" ]; then
    SOURCE_URL="deb https://mirrors.tuna.tsinghua.edu.cn/debian"
    SECURITY_URL="deb https://mirrors.tuna.tsinghua.edu.cn/debian-security"
elif [ "$choice" == "3" ]; then
    SOURCE_URL="deb https://mirrors.cloud.tencent.com/debian"
    SECURITY_URL="deb https://mirrors.cloud.tencent.com/debian-security"
elif [ "$choice" == "4" ]; then
    SOURCE_URL="deb https://mirrors.aliyun.com/debian"
    SECURITY_URL="deb https://mirrors.aliyun.com/debian-security"
elif [ "$choice" == "5" ]; then
    SOURCE_URL="deb http://mirrors.tencentyun.com/debian"
    SECURITY_URL="deb http://mirrors.tencentyun.com/debian-security"
elif [ "$choice" == "6" ]; then
    SOURCE_URL="deb http://mirrors.cloud.aliyuncs.com/debian"
    SECURITY_URL="deb http://mirrors.cloud.aliyuncs.com/debian-security"
else
    echo "无效选项，退出。"
    exit 1
fi

# 备份原有的 sources.list
if [ -f /etc/apt/sources.list ]; then
    mv /etc/apt/sources.list /etc/apt/sources.list.backup
    echo "已备份 /etc/apt/sources.list 为 /etc/apt/sources.list.backup"
fi

# 写入新的 sources.list
cat > /etc/apt/sources.list << EOF
${SOURCE_URL} bookworm main contrib non-free non-free-firmware
deb-src ${SOURCE_URL} bookworm main contrib non-free non-free-firmware

${SOURCE_URL} bookworm-updates main contrib non-free non-free-firmware
deb-src ${SOURCE_URL} bookworm-updates main contrib non-free non-free-firmware

${SOURCE_URL} bookworm-backports main contrib non-free non-free-firmware
deb-src ${SOURCE_URL} bookworm-backports main contrib non-free non-free-firmware

${SECURITY_URL} bookworm-security main contrib non-free non-free-firmware
deb-src ${SECURITY_URL} bookworm-security main contrib non-free non-free-firmware
EOF

echo "新的 /etc/apt/sources.list 已写入完成。"

# 更新软件包列表
apt update -y

echo "apt 更新完成。"
