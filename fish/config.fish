set fish_greeting
set -xg fish_prompt_pwd_dir_length 2
set -xg fish_prompt_pwd_full_dirs 3
set -xg EDITOR nvim
set -xg VISUAL nvim

switch (uname -n)
case 'gigas*'
    function activate-gigas
        set -xg COMPOSE_FILE "$HOME/Prog/gigas/gigas_devenv/docker-compose.yml"
        set -xg CODEPATH "$HOME/Prog/gigas"
        set -xg CODELIBSPATH "$CODEPATH/libs"
        set -xg CODEPKGSPATH "$CODELIBSPATH/npm-packages"
        set -xg HOSTBILL_UID '1000'
        set -xg HOSTBILL_GID '1000'
    end
    activate-gigas
    function deactivate-gigas
        set -e COMPOSE_FILE CODEPATH CODELIBSPATH CODEPKGSPATH HOSTBILL_UID HOSTBILL_GID
    end
end

if status --is-interactive
    abbr -a m math
    abbr -a v nvim
    abbr -a ec 'emacsclient -c -n -a ""'
    abbr -a ecn 'emacsclient -nw -a ""'
    abbr -a zd lazydocker
    abbr -a zj zellij
    abbr -a se sudo -E
    abbr -a sv sudo -E nvim
    abbr -a -- - 'cd -'
    abbr -a ... 'cd ../..'
    abbr -a ..2 'cd ../..'
    abbr -a .... 'cd ../../..'
    abbr -a ..3 'cd ../../..'
    abbr -a ..... 'cd ../../../..'
    abbr -a ..4 'cd ../../../..'
    abbr -a ...... 'cd ../../../../..'
    abbr -a ..5 'cd ../../../../..'
    abbr -a ....... 'cd ../../../../../..'
    abbr -a ..6 'cd ../../../../../..'
    abbr -a ........ 'cd ../../../../../../..'
    abbr -a ..7 'cd ../../../../../../..'
    abbr -a ......... 'cd ../../../../../../../..'
    abbr -a ..8 'cd ../../../../../../../..'
    abbr -a .......... 'cd ../../../../../../../../..'
    abbr -a ..9 'cd ../../../../../../../../..'
    abbr -a ........... 'cd ../../../../../../../../../..'
    abbr -a ..10 'cd ../../../../../../../../../..'
    abbr -a ............ 'cd ../../../../../../../../../../..'
    abbr -a ..11 'cd ../../../../../../../../../../..'
    if type -q exa
        abbr -a l exa
    else
        abbr -a l ls
    end

    bind \cy fish_clipboard_paste
    # bind \cH backward-kill-word
    bind \ez 'commandline -r fg; commandline -f execute'

    if not set -q DELTA_COLUMNS
        set -xg DELTA_COLUMNS 169
    end
    function delta_sidebyside --on-signal WINCH
        if test $COLUMNS -ge $DELTA_COLUMNS
            if test -z "$DELTA_FEATURES"
                set -xga DELTA_FEATURES +side-by-side
            else if ! contains +side-by-side $DELTA_FEATURES
                    and ! contains side-by-side $DELTA_FEATURES
                set -xga DELTA_FEATURES side-by-side
            end
        else
            if test "$DELTA_FEATURES" = +side-by-side
                set -ge DELTA_FEATURES
            else if contains side-by-side $DELTA_FEATURES
                set -ge DELTA_FEATURES[(contains --index side-by-side $DELTA_FEATURES)]
            end
        end
    end
    delta_sidebyside

    if not set -q FISH_TITLE_CMD_MAX_LEN
        set -xg FISH_TITLE_CMD_MAX_LEN 40
    end
    function fish_title
        # emacs' "term" is basically the only term that can't handle it.
        if not set -q INSIDE_EMACS; or string match -vq '*,term:*' -- $INSIDE_EMACS
            # If we're connected via ssh, we print the hostname.
            set -l ssh
            set -q SSH_TTY
            and set ssh "["(prompt_hostname | string sub -l 10 | string collect)"]"
            # An override for the current command is passed as the first parameter.
            # This is used by `fg` to show the true process name, among others.
            if set -q argv[1]
                echo -- $ssh (prompt_pwd -d 1 -D 1)❯ (string sub -l $FISH_TITLE_CMD_MAX_LEN -- $argv[1])
            else
                # Don't print "fish" because it's redundant
                set -l command (status current-command)
                if test "$command" = fish
                    set command
                end
                echo -- $ssh (prompt_pwd -d 1 -D 1)❯ (string sub -l $FISH_TITLE_CMD_MAX_LEN -- $command)
            end
        end
    end

    function zoxide-add-for -a times folder
        for i in $(seq $times); zoxide add $folder; end
    end
    zoxide init fish | source
    starship init fish | source

    set -l banners
    if type -q flashfetch
        set -a banners 'timeout -k 1s 0.75s flashfetch'
    end
    if type -q unsplash-feh
        set -a banners 'unsplash-feh &'
    end
    if test -d ~/tmp/shell-color-scripts
        set -a banners 'eval (random choice ~/tmp/shell-color-scripts/colorscripts/*)'
    end
    if test -d ~/tmp/ansi
        set -a banners 'cat (random choice ~/tmp/ansi/*.ansi)'
    end
    eval (random choice $banners)
end
