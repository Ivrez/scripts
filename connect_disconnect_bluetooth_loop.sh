#!/bin/bash

TARGET_NAME="device_name"
LOOP_INTERVAL=20

scan_bluetooth() {
    blueutil --inquiry | grep "$TARGET_NAME" | awk -F ', ' '/address:/ {print $1}' | cut -d ' ' -f2
}

connect_device() {
    echo "🔗 Подключение к \"$TARGET_NAME\" ($1)..."
    blueutil --connect "$1"
}

disconnect_device() {
    echo "🔌 Отключение от \"$TARGET_NAME\" ($1)..."
    blueutil --disconnect "$1"
}

echo "🔍 Ищем устройство '$TARGET_NAME'..."
mac_address=$(scan_bluetooth)

if [[ -z "$mac_address" ]]; then
    echo "❌ Устройство '$TARGET_NAME' не найдено! Выход..."
    exit 1
fi

echo "🎯 Найдено: $TARGET_NAME ($mac_address)"
echo "🔄 Запуск цикла подключения и отключения..."

while true; do
    connect_device "$mac_address"
    sleep "$LOOP_INTERVAL"
    disconnect_device "$mac_address"
    sleep "$LOOP_INTERVAL"
done
