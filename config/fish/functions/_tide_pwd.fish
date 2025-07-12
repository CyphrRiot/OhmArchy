function _tide_pwd
    # Simple, no-truncation version of tide pwd
    set -l pwd_display (string replace -r "^$HOME" ' ~' -- $PWD)
    
    # Use tide colors but keep it simple
    set_color normal -b $tide_pwd_bg_color
    set_color $tide_pwd_color_dirs
    echo -n "$tide_pwd_icon$pwd_display"
    
    # Set the length variable that other tide functions expect  
    string length -V "$tide_pwd_icon$pwd_display" | read -g _tide_pwd_len
end
