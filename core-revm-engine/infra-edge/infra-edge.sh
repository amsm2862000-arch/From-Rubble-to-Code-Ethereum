#!/bin/bash
# ==============================================================================
# CONTROL ENGINE - RESOURCE-AWARE ADAPTIVE THROTTLING LOOP (PHASE 1)
# ==============================================================================

set -e

if [ -f .env ]; then
    source .env
else
    exit 1
fi

readonly HARDWARE_TAMPER_SENSOR_PATH
echo "[INIT] Booting Adaptive Compute Resource Allocation Daemon..."

CLEAN_SENSOR_PATH=$(realpath -q "$HARDWARE_TAMPER_SENSOR_PATH" 2>/dev/null || echo "/dev/null")
if [ -f "$CLEAN_SENSOR_PATH" ]; then
    SYSTEM_BATTERY_STATE=$(cat "$CLEAN_SENSOR_PATH")
else
    SYSTEM_BATTERY_STATE="UNKNOWN"
fi

# FIXED: Resource-Aware Throttling Matrix to prevent hardware meltdown during long fuzzing campaigns
if [ "$SYSTEM_BATTERY_STATE" == "Discharging" ]; then
    echo "[COMPUTE THROTTLE] Host system running on backup power. Reducing resource allocation..."
    # Lowering the rate limit to throttle computing and cool down hardware
    sed -i 's/DRIP_SYNC_RATE_LIMIT=.*/DRIP_SYNC_RATE_LIMIT=2/' .env
    echo "[COMPUTE RE-ALLOCATED] System throttled to 2 tx/s to protect node hardware."
else
    echo "[COMPUTE OPTIMAL] Power matrix stable. Unleashing maximum fuzzing core velocity."
    sed -i 's/DRIP_SYNC_RATE_LIMIT=.*/DRIP_SYNC_RATE_LIMIT=10/' .env
fi

# Standard anti-tamper and connectivity loops proceed below...
