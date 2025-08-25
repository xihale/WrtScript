#!/bin/sh

MAC_FILE="/root/mac"

# 获取当前MAC地址并保存到文件
save_mac() {
    CURRENT_MAC=$(ip link show eth0 | grep ether | awk '{print $2}')
    echo "当前的MAC地址是: $CURRENT_MAC"
    echo "$CURRENT_MAC" > "$MAC_FILE"
    echo "已保存当前MAC地址到 $MAC_FILE"
}

# 从文件中恢复MAC地址
restore_mac() {
    if [ -f "$MAC_FILE" ]; then
        SAVED_MAC=$(cat "$MAC_FILE")
        echo "从文件恢复MAC地址: $SAVED_MAC"
        ip link set dev eth0 down
        ip link set dev eth0 address "$SAVED_MAC"
        ip link set dev eth0 up
        echo "已恢复MAC地址到eth0"
    else
        echo "MAC文件不存在，无法恢复MAC地址"
    fi
}

# 检查参数并执行对应的操作
if [ "$1" = "save" ]; then
    save_mac
elif [ "$1" = "restore" ]; then
    restore_mac
else
    echo "用法: $0 {save|restore}"
    echo "save: 保存当前的MAC地址"
    echo "restore: 恢复之前保存的MAC地址"
fi

