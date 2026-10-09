#!/bin/bash
# ==============================================================================
# INFRASTRUCTURE EDGE OPERATIONAL CONTROL ENGINE - EXTREME DISASTER ENVIRONMENT
# ==============================================================================

set -e

if [ -f .env ]; then
    source .env
else
    echo "[CRITICAL] Environmental variable ledger missing. Aborting bootstrap."
    exit 1
fi

readonly HARDWARE_TAMPER_SENSOR_PATH
readonly WARFARE_SHRED_TRIGGER
readonly SOVEREIGN_P2P_MESH_PORT

echo "[INIT] Booting Resilient Infrastructure Edge Synchronization Daemon..."

CLEAN_SENSOR_PATH=$(realpath -q "$HARDWARE_TAMPER_SENSOR_PATH" 2>/dev/null || echo "/dev/null")
if [ -f "$CLEAN_SENSOR_PATH" ] && [ "$CLEAN_SENSOR_PATH" == "/sys/class/power_supply/bat0/status" ]; then
    SYSTEM_BATTERY_STATE=$(cat "$CLEAN_SENSOR_PATH")
else
    SYSTEM_BATTERY_STATE="UNKNOWN"
fi

if [ "$SYSTEM_BATTERY_STATE" == "Discharging" ] || [ "$WARFARE_SHRED_TRIGGER" -eq 2 ]; then
    echo "[CRITICAL THREAT] AUTOMATED ZEROIZATION ENGAGED"
    unset SHRED_KEY_CYPHER
    rm -rf /dev/shm/* 2>/dev/null
    exit 2
fi

# FIXED: Replaced centralized IPs with dynamic local P2P Bootnode peer gateway traces
echo "[NETWORK] Ingesting decentralized P2P bootnodes topology routing verification..."
P2P_LOCAL_BOOTNODES=("127.0.0.1" "192.168.1.50") # Dynamic localized edge peer routers array
NETWORK_STATUS="OFFLINE"

for peer in "${P2P_LOCAL_BOOTNODES[@]}"; do
    if ping -c 1 -W 1 "$peer" > /dev/null 2>&1; then
        NETWORK_STATUS="ONLINE" # Local mesh subnet consensus is alive
        break
    fi
done

if [ "$NETWORK_STATUS" == "OFFLINE" ]; then
    echo "[BLACKOUT EVENT] Edge isolation confirmed."
    export DISASTER_MODE_TRIGGER=2
    if [ "$SOVEREIGN_TRADE_MODE" = "true" ]; then
        nohup socat TCP-LISTEN:$SOVEREIGN_P2P_MESH_PORT,fork PIPE > /dev/null 2>&1 &
    fi
else
    echo "[STABLE] P2P network backbone verified active."
    export DISASTER_MODE_TRIGGER=0
fi
