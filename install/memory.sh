# Memory optimization configuration
echo "Configuring memory management optimization..."

# Create sysctl configuration for memory optimization
sudo tee /etc/sysctl.d/99-memory-optimization.conf >/dev/null <<EOF
# Memory Management Optimization
# Reserve 1GB of uncached RAM minimum
vm.min_free_kbytes=1048576

# Reduce cache pressure (default: 100, lower = less aggressive)
vm.vfs_cache_pressure=50

# Reduce swappiness (default: 60, lower = prefer RAM over swap)
vm.swappiness=10

# Limit dirty page cache to reduce memory pressure
vm.dirty_ratio=5
vm.dirty_background_ratio=2

# Improve memory reclaim efficiency
vm.zone_reclaim_mode=0
EOF

# Apply settings immediately
sudo sysctl --system

# Verify settings were applied
echo "Memory optimization settings applied:"
# Store sysctl values to avoid redundant calls
min_free_kb=$(sysctl vm.min_free_kbytes | cut -d= -f2 | tr -d ' ')
cache_pressure=$(sysctl vm.vfs_cache_pressure | cut -d= -f2 | tr -d ' ')
swappiness=$(sysctl vm.swappiness | cut -d= -f2 | tr -d ' ')

# Use bash arithmetic instead of bc dependency
min_free_mb=$((min_free_kb / 1024))
echo "Min free memory: ${min_free_kb} KB (${min_free_mb} MB)"
echo "Cache pressure: ${cache_pressure}"
echo "Swappiness: ${swappiness}"
echo "✓ Memory optimization configured"
