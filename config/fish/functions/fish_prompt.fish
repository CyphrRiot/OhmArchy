function fish_prompt
    # Get current directory
    set -l pwd (basename (prompt_pwd))
    if test "$pwd" = "/"
        set pwd "/"
    end

    # Colors
    set -l blue (set_color blue)
    set -l cyan (set_color cyan)
    set -l normal (set_color normal)

    # Simple prompt: blue directory, cyan arrow
    echo -n $blue$pwd$normal" "$cyan">"$normal" "
end
