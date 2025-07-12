# Check if there's a fish_postexec function that might be sending notifications
function fish_postexec --on-event fish_postexec
    # Do nothing - just override any existing postexec function
    # This prevents any command completion notifications
end