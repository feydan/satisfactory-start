#!/bin/sh

shutdownIdleMinutes=20
idleCheckFrequencySeconds=1

isIdle=0
while [  $isIdle -le 0 ]; do
    idle=1
    iterations=$(($idleCheckFrequencySeconds * 60 * $shutdownIdleMinutes))
    while [$counter -lt $iterations]; do
        connectionBytes=$(ss -lu | grep 777 | awk -F ' ' '{s+=$2} END {print s}')
        if [$connectionBytes -gt 0]; then
            idle=0
            echo "Activity detected, resetting shutdown timer to $shutdownIdleMinutes minutes."
            break
        fi
        counter++
        sleep $idleCheckFrequencySeconds
    done
done

echo "No activity detected for $shutdownIdleMinutes, shutting down."

# shutdown now