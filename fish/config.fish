set fish_greeting
set -xg fish_prompt_pwd_dir_length 2
set -xg fish_prompt_pwd_full_dirs 3
set -xg EDITOR vi
set -xg VISUAL vi

switch (uname -n)
case 'gigas*'
    set -xg COMPOSE_FILE "$HOME/Prog/gigas/gigas_devenv/docker-compose.yml"
    set -xg CODEPATH "$HOME/Prog/gigas"
    set -xg CODELIBSPATH "$CODEPATH/libs"
    set -xg CODEPKGSPATH "$CODELIBSPATH/npm-packages"
    set -xg HOSTBILL_UID '1000'
    set -xg HOSTBILL_GID '1000'
end

abbr -a m math
abbr -a ec 'emacsclient -c -n -a ""'
abbr -a ecn 'emacsclient -nw -a ""'
abbr -a zd lazydocker
abbr -a zj zellij
abbr -a svi sudo -E vi
abbr -a -- - 'cd -'
abbr -a ..2 'cd ../..'
abbr -a ..3 'cd ../../..'
abbr -a ..4 'cd ../../../..'
abbr -a ..5 'cd ../../../../..'
abbr -a ..6 'cd ../../../../../..'
abbr -a ..7 'cd ../../../../../../..'
abbr -a ..8 'cd ../../../../../../../..'
abbr -a ..9 'cd ../../../../../../../../..'

bind \ez 'commandline -r fg; commandline -f execute'

zoxide init fish | source
starship init fish | source
