#!/bin/bash
# ==============================================================================
# INFRASTRUCTURE EDGE ADAPTIVE RUNTIME SIGNAL THROTTLER & CROSS-PLATFORM SYSTEM
# ==============================================================================

set -e
source .env 2>/dev/null || exit 1

readonly HARDWARE_TAMPER_SENSOR_PATH
readonly SOVEREIGN_P2P_MESH_PORT

# Find target Python orchestrator PID safely
PYTHON_PID=$(pgrep -f "pipeline.py" | head -n 1 || echo "")

echo "[CROSS-PLATFORM INSPECT] Checking system hardware metric layers..."

# FIXED: Cross-platform battery trace interface mapping to stop crash conditions
SYSTEM_BATTERY_STATE="UNKNOWN"
if [ -f "$HARDWARE_TAMPER_SENSOR_PATH" ]; then
    SYSTEM_BATTERY_STATE=$(cat "$HARDWARE_TAMPER_SENSOR_PATH")
elif command -v pmset &> /dev/null; then
    # Fallback checkpoint tracking for macOS hosts
    SYSTEM_BATTERY_STATE=$(pmset -g batt | grep -q "drawing from 'Battery Power'" && echo "Discharging" || echo "Charging")
elif command -v upower &> /dev/null; then
    # Fallback checkpoint tracking for multi-tenant Linux server nodes
    SYSTEM_BATTERY_STATE=$(upower -i $(upower -e | grep battery) | grep state | awk '{print $2}')
fi

echo "[HARDWARE MATRIX] Finalized target platform profile result: $SYSTEM_BATTERY_STATE"

# FIXED: Replaced sed string modification with clean dynamic OS signal handling (SIGUSR1/SIGUSR2)
if [ "$SYSTEM_BATTERY_STATE" == "Discharging" ]; then
    echo "[RESOURCE PROTECTION] Critical power drift. Injecting SIGUSR1 to active memory loop..."
    if [ ! -z "$PYTHON_PID" ]; then
        kill -10 "$PYTHON_PID" 2>/dev/null # Sends SIGUSR1 to throttle python in real-time
    fi
else
    echo "[RESOURCE HIGH-CAPACITY] Power optimal. Injecting SIGUSR2 to restore maximum pipeline throughput..."
    if [ ! -z "$PYTHON_PID" ]; then
        kill -12 "$PYTHON_PID" 2>/dev/null # Sends SIGUSR2 to restore speed
    fi
fi

# Multi-peer trace fallback mapping matrix
P2P_LOCAL_BOOTNODES=("127.0.0.1" "192.168.1.50")
NETWORK_STATUS="OFFLINE"
for peer in "${P2P_LOCAL_BOOTNODES[@]}"; do
    if ping -c 1 -W 1 "$peer" > /dev/null 2>&1; then
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
