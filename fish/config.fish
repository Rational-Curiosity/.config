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

set -xg DELTA_COLUMNS 169
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

abbr -a m math
abbr -a v nvim
abbr -a ec 'emacsclient -c -n -a ""'
abbr -a ecn 'emacsclient -nw -a ""'
abbr -a zd lazydocker
abbr -a zj zellij
abbr -a sv sudo -E nvim
abbr -a -- - 'cd -'
abbr -a ..2 'cd ../..'
abbr -a ..3 'cd ../../..'
abbr -a ..4 'cd ../../../..'
abbr -a ..5 'cd ../../../../..'
abbr -a ..6 'cd ../../../../../..'
abbr -a ..7 'cd ../../../../../../..'
abbr -a ..8 'cd ../../../../../../../..'
abbr -a ..9 'cd ../../../../../../../../..'
abbr -a ..10 'cd ../../../../../../../../../..'
abbr -a ..11 'cd ../../../../../../../../../../..'

bind \ez 'commandline -r fg; commandline -f execute'

function zoxide-add-for -a times folder
    for i in $(seq $times); zoxide add $folder; end
end
zoxide init fish | source
starship init fish | source
