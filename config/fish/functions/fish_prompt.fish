function fish_prompt
    # Get current directory, shortened
    set -l pwd (prompt_pwd)

    # Set basic colors
    set -l normal (set_color normal)
    set -l blue (set_color blue)
    set -l yellow (set_color yellow)
    set -l cyan (set_color cyan)
    set -l red (set_color red)

    # Start prompt with directory
    echo -n $blue$pwd$normal

    # Add git info if in git repo
    if git rev-parse --git-dir >/dev/null 2>&1
        set -l branch (git branch 2>/dev/null | grep '* ' | sed 's/* //')
        if test -n "$branch"
            echo -n " "$yellow"("$branch")"$normal

            # Show git status
            if not git diff --quiet 2>/dev/null
                echo -n $red"*"$normal
            end
        end
    end

    # Prompt symbol
    echo -n " "$cyan"❱ "$normal
end
