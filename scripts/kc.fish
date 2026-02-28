#!/usr/bin/env fish

# Keep Connection - 自动检测连接状态并在断线时重拨

source utils_lib.fish

# 配置
set overhead_interval 1 # 检测间隔
set check_url "http://connect.rom.miui.com/generate_204"

function reconnect
    echo "Network appears to be down... Reconnecting..."
    /root/generate_mac.sh

    while true
        set gateway (ip route | grep "default via" | awk '{print $3}')
        if test -n "$gateway"
            log_success "Gateway detected: $gateway"
            break
        end
        sleep 1
    end

    /root/login.fish
    # sleep 25
    # /root/ip.fish

    echo "Waiting for network to stabilize..."
    echo "Attempting to get new gateway address after reconnection..."
end

while true
    set http_code (curl -I -s -o /dev/null -w "%{http_code}" $check_url 2>/dev/null)

    if test "$http_code" != 204
        log_info "Connection check failed (HTTP $http_code). Reconnecting..."
        reconnect
    else
        log_success "Connection check to $check_url successful."
    end

    sleep $overhead_interval
end
