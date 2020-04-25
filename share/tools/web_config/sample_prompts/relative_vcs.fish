# name: Relative VCS
# author: Andreas Nordal

function fish_prompt --description 'Write out the prompt'
    set -l last_pipestatus $pipestatus
    set -l normal (set_color normal)

    # Color the prompt differently when we're root
    set -l color_cwd $fish_color_cwd
    set -l suffix '>'
    if contains -- $USER root toor
        if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
        end
        set suffix '#'
    end

    # If we're running via SSH, change the host color.
    set -l color_host $fish_color_host
    if set -q SSH_TTY
        set color_host $fish_color_host_remote
    end

    set -l pre $PWD
    set -l post ''
    set -l vcs (git rev-parse --show-toplevel --show-prefix --abbrev-ref HEAD 2>/dev/null)
    and begin
        set pre $vcs[1]
        set post (string replace -r '^(.*)/$' '/$1' $vcs[2])
        set vcs '['$vcs[3]']'
    end
    set pre (string replace -r '^'$HOME'($|/)' '~$1' $pre)

    set -l pipestring
    if test "$last_pipestatus" != 0
        for i in $last_pipestatus
            set pipestring "$pipestring "(__fish_status_to_signal $i)
        end
    end

    echo -ns (set_color $fish_color_user) "$USER" $normal @ (set_color $color_host) (prompt_hostname) $normal ' ' \
        (set_color $color_cwd) $pre (set_color --bold yellow) $vcs $normal (set_color $color_cwd) $post $normal $pipestring $suffix ' '
end
