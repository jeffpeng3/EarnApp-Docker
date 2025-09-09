#!/bin/bash
echo "Installing"
cp /download/earnapp /usr/bin/earnapp
chmod a+wr /etc/earnapp/
touch /etc/earnapp/status
chmod a+wr /etc/earnapp/status
printf $EARNAPP_UUID > /etc/earnapp/uuid

earnapp stop
sleep 2
earnapp start
sleep 2
echo "Earnapp is running"

fail_count=0
while [ $fail_count -lt 3 ]; do
    if ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
        fail_count=0
    else
        fail_count=$((fail_count + 1))
    fi
    if [ $fail_count -ge 3 ]; then
        echo "網路連線失敗超過三次，結束容器"
        exit 1
    fi
    sleep 30
done
