set -xg EDITOR nvim
set -xg VISUAL nvim

if not status --is-interactive
    exit
end

abbr -a c bc -l
abbr -a d disown
abbr -a ec 'emacsclient -c -n -a ""'
abbr -a ecn 'emacsclient -nw -a ""'
abbr -a l ls
abbr -a m math
abbr -a se sudo -E
abbr -a sv sudo -E nvim
abbr -a v nvim
abbr -a zd lazydocker
abbr -a zj zellij
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

fish_vi_key_bindings

bind -M insert \ck kill-line

bind -M insert \ca beginning-of-line
bind -M insert \ce end-of-line
bind -M insert \ch backward-delete-char
bind -M insert \cp up-or-search
bind -M insert \cn down-or-search
bind -M insert \cf forward-char
bind -M insert \cb backward-char
bind -M insert \ct transpose-chars
bind -M insert \cg cancel
bind -M insert \c_ undo
bind -M insert \cz undo

bind -M insert \cr history-pager
bind -M insert \e\x7f backward-kill-word
bind -M insert \e\b backward-kill-word
bind -M insert \eb prevd-or-backward-word
bind -M insert \ef nextd-or-forward-word

bind \cy fish_clipboard_paste
bind -M insert \cy fish_clipboard_paste
# bind \cH backward-kill-word
bind \ez 'commandline -r fg; commandline -f execute'
bind -M insert \ez 'commandline -r fg; commandline -f execute'

set fish_greeting
set -xg fish_prompt_pwd_dir_length 2
set -xg fish_prompt_pwd_full_dirs 3
set -xg FZF_DEFAULT_OPTS --cycle
set -xg SKIM_DEFAULT_COMMAND "fd --type f --color never -H -E .git -E '[._]*cache*' -E .log"
set -xg SKIM_DEFAULT_OPTIONS "-m --bind 'alt-a:page-up,alt-e:page-down,alt-p:preview-up,alt-n:preview-down,alt-v:preview-page-up,ctrl-v:preview-page-down,ctrl-k:kill-line' --preview='bat --color always {}||exa -l {}'"

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

function interface
    ip route | grep '^default' | cut -d' ' -f5
end
function mtu -a itf
    if test -z "$itf"
        set itf (interface)
    end
    ip link show "$itf" | sed -nr 's/^.* mtu ([0-9]+) .*$/\1/p'
end

function weather
    set -l CACHE ~/.cache/weather.response
    set -l MAX_TIME 0.8
    set -l CMD
    if type -q wego
        # go install github.com/schachmat/wego@latest
        # owm-api-key=271e944f618513ad8ed9f7d5d75f6175
        set CMD 'wego -l "$CITY"'
    else
        set CMD 'curl -s -m "$MAX_TIME" "wttr.in/$CITY"'
    end
    while set -q argv[1]
        switch $argv[1]
        case --clear
            rm -f "$CACHE"
        case --city
            curl -s -m "$MAX_TIME" ipinfo.io
            return
        case -m --max-time
            set MAX_TIME $argv[2]
            set -e argv[1]
        case --wego
            set CMD 'wego -l "$CITY"'
        case --wttr
            set CMD 'curl -s -m "$MAX_TIME" "wttr.in/$CITY"'
        case '*'
            rm -f "$CACHE"
            set CITY "$argv[1]"
        end
        set -e argv[1]
    end
    set -l SINCE
    if not test -f $CACHE
            or begin set SINCE (math \( (date +%s) - (date -r $CACHE +%s) \) / 3600); test $SINCE -gt 5; end
        if not set -q CITY
            set CITY "$(curl -s -m "$MAX_TIME" ipinfo.io|jq -nrM 'try (input|.city) catch "Madrid"')"
            if test $pipestatus[1] -ne 0
                echo 'weather: Failed to get city name from ipinfo.io' >&2
            end
            switch $CITY
            case 'Aranda de Duero' Zaragoza
                set CITY Ponferrada
            end
        end

        eval $CMD|sed -E 's/\x1b\[([0-9;]+);5m([^\x1b]+)\x1b\[([0-9;]+);25m/\x1b\[\1m\2\x1b\[\3m/g'\
            > $CACHE
        if test $pipestatus[1] -ne 0
            rm -f $CACHE
            echo 'weather: Failed to get weather from wttr.in' >&2
            return
        end
    else
        echo "weather: data getted $(math floor $SINCE) hours $(math round $SINCE % 1 x 60) minutes ago" >&2
    end
    if test $COLUMNS -lt 125
        sed -E "s/^[┌│├└ ][ ─]//;s/^([^\x1b]|(\x1b\[[0-9;]+m)+[^\x1b]){$(math "ceil((123-$COLUMNS)/2)")}(([^\x1b]|(\x1b\[[0-9;]+m)+[^\x1b]){$COLUMNS}).*\$/\3\x1b\[0m/" $CACHE
    else
        cat $CACHE
    end
end

if not set -q NVIM && not set -q INSIDE_EMACS && test $COLUMNS -ge 90
    set -l banners
    if ping -q -c 1 -W 0.5 wttr.in &>/dev/null
        set -a banners 'weather'
    end
    if type -q flashfetch
        set -a banners 'LC_ALL=C timeout -k 1.25s 1.0s flashfetch'
    end
    # if type -q unsplash-feh
    #     set -a banners 'unsplash-feh &; disown'
    # end
    if test -d ~/tmp/shell-color-scripts
        set -a banners 'eval (random choice ~/tmp/shell-color-scripts/colorscripts/*)'
    end
    if test -d ~/tmp/ansi
        set -a banners 'cat (random choice ~/tmp/ansi/*.ansi)'
    end
    eval (random choice $banners)
end
