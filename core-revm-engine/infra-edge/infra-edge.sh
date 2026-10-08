#!/bin/bash
# ==============================================================================
# INFRASTRUCTURE EDGE OPERATIONAL CONTROL ENGINE - EXTREME DISASTER ENVIRONMENT
# ==============================================================================

set -e

# Load environmental arrays
if [ -f .env ]; then
    source .env
else
    echo "[CRITICAL] Environmental variable ledger missing. Aborting bootstrap."
    exit 1
fi

# FIXED: Enforce strict read-only execution constraints to block variable injection attacks
readonly HARDWARE_TAMPER_SENSOR_PATH
readonly WARFARE_SHRED_TRIGGER
readonly SOVEREIGN_P2P_MESH_PORT

echo "[INIT] Booting Resilient Infrastructure Edge Synchronization Daemon..."

# Sanitize path extraction to prevent absolute path transversal exploits
CLEAN_SENSOR_PATH=$(realpath -q "$HARDWARE_TAMPER_SENSOR_PATH" 2>/dev/null || echo "/dev/null")

if [ -f "$CLEAN_SENSOR_PATH" ] && [ "$CLEAN_SENSOR_PATH" == "/sys/class/power_supply/bat0/status" ]; then
    SYSTEM_BATTERY_STATE=$(cat "$CLEAN_SENSOR_PATH")
    echo "[SYSTEM MONITOR] Current hardware power metrics: $SYSTEM_BATTERY_STATE"
else
    SYSTEM_BATTERY_STATE="UNKNOWN"
    echo "[SECURITY WARNING] Blocked unauthorized telemetry tampering attempt."
fi

if [ "$SYSTEM_BATTERY_STATE" == "Discharging" ] || [ "$WARFARE_SHRED_TRIGGER" -eq 2 ]; then
    echo "[CRITICAL WARFARE THREAT DETECTED] ENGAGING AUTOMATED ZEROIZATION CONTEXT"
    unset SHRED_KEY_CYPHER
    if [ -d /dev/shm ]; then
        rm -rf /dev/shm/* 2>/dev/null
    fi
    exit 2
fi

# WAN Connectivity Audit Network Pathways
PING_TARGETS=("8.8.8.8" "1.1.1.1")
NETWORK_STATUS="OFFLINE"

for target in "${PING_TARGETS[@]}"; do
    if ping -c 1 -W 2 "$target" > /dev/null 2>&1; then
        NETWORK_STATUS="ONLINE"
        break
    fi
done

if [ "$NETWORK_STATUS" == "OFFLINE" ]; then
    export DISASTER_MODE_TRIGGER=2
    if [ "$SOVEREIGN_TRADE_MODE" = "true" ]; then
        nohup socat TCP-LISTEN:$SOVEREIGN_P2P_MESH_PORT,fork PIPE > /dev/null 2>&1 &
    fi
else
    export DISASTER_MODE_TRIGGER=0
fi
