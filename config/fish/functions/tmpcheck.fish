function tmpcheck
    df -h /tmp
    echo
    du -sh /tmp/* 2>/dev/null | sort -hr | head -10
end
