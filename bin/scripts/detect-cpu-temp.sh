#!/bin/bash

# OhmArchy CPU Temperature Sensor Auto-Detection Script
# Automatically finds the best CPU temperature sensor for waybar
# Works across different hardware configurations

# Function to check if a path exists and is readable
check_temp_source() {
    local path="$1"
    if [[ -r "$path" ]]; then
        local temp=$(cat "$path" 2>/dev/null)
        if [[ $temp =~ ^[0-9]+$ ]] && [[ $temp -gt 10000 ]] && [[ $temp -lt 150000 ]]; then
            echo "$path"
            return 0
        fi
    fi
    return 1
}

# Function to find coretemp hwmon path
find_coretemp_hwmon() {
    for hwmon in /sys/class/hwmon/hwmon*; do
        if [[ -r "$hwmon/name" ]]; then
            local name=$(cat "$hwmon/name" 2>/dev/null)
            if [[ "$name" == "coretemp" ]]; then
                # Look for Package temp (usually temp1_input)
                for temp_input in "$hwmon"/temp*_input; do
                    if [[ -r "$temp_input" ]]; then
                        local label_file="${temp_input%_input}_label"
                        if [[ -r "$label_file" ]]; then
                            local label=$(cat "$label_file" 2>/dev/null)
                            if [[ "$label" =~ Package ]]; then
                                echo "$temp_input"
                                return 0
                            fi
                        else
                            # If no label, temp1 is usually package temp
                            if [[ "$temp_input" =~ temp1_input$ ]]; then
                                echo "$temp_input"
                                return 0
                            fi
                        fi
                    fi
                done
            fi
        fi
    done
    return 1
}

# Function to find best thermal zone
find_thermal_zone() {
    # Preferred thermal zone types in order of preference
    local preferred_types=("x86_pkg_temp" "TCPU" "TCPU_PCI" "acpi_thermal_zone")

    for zone_type in "${preferred_types[@]}"; do
        for zone in /sys/class/thermal/thermal_zone*; do
            if [[ -r "$zone/type" ]]; then
                local type=$(cat "$zone/type" 2>/dev/null)
                if [[ "$type" == "$zone_type" ]]; then
                    local temp_path="$zone/temp"
                    if check_temp_source "$temp_path" >/dev/null; then
                        echo "$temp_path"
                        return 0
                    fi
                fi
            fi
        done
    done

    # Fallback: find any working thermal zone with reasonable temperature
    for zone in /sys/class/thermal/thermal_zone*; do
        local temp_path="$zone/temp"
        if check_temp_source "$temp_path" >/dev/null; then
            local temp=$(cat "$temp_path" 2>/dev/null)
            # Only use if temperature is in reasonable CPU range (30-100°C)
            if [[ $temp -gt 30000 ]] && [[ $temp -lt 100000 ]]; then
                echo "$temp_path"
                return 0
            fi
        fi
    done

    return 1
}

# Main detection logic
detect_cpu_temp() {
    local temp_sources=()

    # 1. Try to find coretemp hwmon (most reliable)
    local coretemp_path=$(find_coretemp_hwmon)
    if [[ -n "$coretemp_path" ]]; then
        temp_sources+=("$coretemp_path")
    fi

    # 2. Try to find good thermal zones
    local thermal_path=$(find_thermal_zone)
    if [[ -n "$thermal_path" ]]; then
        temp_sources+=("$thermal_path")
    fi

    # 3. Add common fallback paths
    local fallback_paths=(
        "/sys/class/hwmon/hwmon0/temp1_input"
        "/sys/class/hwmon/hwmon1/temp1_input"
        "/sys/class/hwmon/hwmon2/temp1_input"
        "/sys/class/thermal/thermal_zone0/temp"
        "/sys/class/thermal/thermal_zone1/temp"
    )

    for path in "${fallback_paths[@]}"; do
        if check_temp_source "$path" >/dev/null; then
            temp_sources+=("$path")
        fi
    done

    # Return unique paths
    printf '%s\n' "${temp_sources[@]}" | sort -u
}

# Command line options
case "${1:-detect}" in
    "detect")
        echo "# Auto-detected CPU temperature sources (in order of preference):"
        temp_paths=$(detect_cpu_temp)
        if [[ -n "$temp_paths" ]]; then
            echo "$temp_paths" | while read -r path; do
                if [[ -n "$path" ]]; then
                    temp=$(cat "$path" 2>/dev/null)
                    temp_c=$((temp / 1000))
                    echo "\"$path\",  // ${temp_c}°C"
                fi
            done
        else
            echo "# No suitable temperature sources found"
            echo "\"/sys/class/thermal/thermal_zone0/temp\",  // fallback"
        fi
        ;;
    "test")
        echo "Testing temperature sources:"
        temp_paths=$(detect_cpu_temp)
        if [[ -n "$temp_paths" ]]; then
            echo "$temp_paths" | while read -r path; do
                if [[ -n "$path" ]]; then
                    temp=$(cat "$path" 2>/dev/null)
                    temp_c=$((temp / 1000))
                    echo "  $path: ${temp_c}°C"
                fi
            done
        else
            echo "  No suitable temperature sources found"
        fi
        ;;
    "waybar")
        echo "\"hwmon-path\": ["
        temp_paths=$(detect_cpu_temp)
        if [[ -n "$temp_paths" ]]; then
            echo "$temp_paths" | while read -r path; do
                if [[ -n "$path" ]]; then
                    echo "    \"$path\","
                fi
            done
        else
            echo "    \"/sys/class/thermal/thermal_zone0/temp\""
        fi
        echo "],"
        ;;
    "help"|"-h"|"--help")
        echo "Usage: $0 [detect|test|waybar|help]"
        echo "  detect  - Show detected paths with comments (default)"
        echo "  test    - Test all detected paths and show current temperatures"
        echo "  waybar  - Output in waybar config format"
        echo "  help    - Show this help message"
        ;;
    *)
        echo "Unknown option: $1"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac
