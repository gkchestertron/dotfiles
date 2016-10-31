export CLUTCH_ENV=stage
for f in /etc/bash_completion.d/*; do source $f; done

set -o vi

rechrome () {
  osascript -e 'activate application "Google Chrome"'
  osascript -e 'tell application "System Events" to keystroke "r" using {command down}'
}

stacktrace () {
  files=""
  paste=`pbpaste`
  cmd="set statusline=%F | set laststatus=2 | copen | set switchbuf+=usetab,newtab"
  cur_dir="${PWD##*/}"

  while read -r line
  do
    file=`echo $line | awk "{gsub(/^.+$cur_dir\//, \"\"); gsub(/:.+$/, \"\")}1"`
    linenumber=`echo $line | awk '{gsub(/^[^:]+:/, ""); gsub(/:[^:]+$/, "")}1'`
    col=`echo $line | awk '{gsub(/.+:/, ""); gsub(/[).]*$/, "")}1'`
    files="$files {\"filename\":\"$file\", \"lnum\": $linenumber, \"col\": $col},"
  done <<< "$paste"

  cmd="call setqflist([$files]) | $cmd"

  vim -c "$cmd"
}

viff () {
  diff=$1
  input=`git diff $diff --name-only`
  files=""

  while read -r line
  do
    files="$files {\"filename\":\"$line\", \"lnum\":1},"
  done <<< "$input"

  vim -c "call setqflist([$files]) | copen | set switchbuf+=usetab,newtab"
}

alias bestcohort='ssh stage -t screen -r'
alias clutch='cd ~/projects/woodshop/skyClutch/'
alias stageclutch='export CLUTCH_ENV=stage'
alias localclutch='export CLUTCH_ENV=local'
alias postgresser='postgres -D /usr/local/var/postgres'
alias crosscomp='export PATH="$HOME/opt/cross/bin:$PATH"'
alias woodshop='cd ~/projects/woodshop/'
alias mycom='sudo /Library/StartupItems/MySQLCOM/MySQLCOM'
alias mampdocs='cd /Applications/MAMP/htdocs/'
alias pyserv='python -m SimpleHTTPServer & open http://localhost:8000'
alias sub='open -a "Sublime Text"'
alias phpserv='sudo apachectl -d $PWD -k start && open http://localhost'
alias phpstop='sudo apachectl -d $PWD -k stop'
alias gdiff='git diff --color=always | less -r'
alias masterbase='git rebase master'
alias gethead='git checkout master; git svn rebase;'
alias pushup='git svn dcommit --dry-run; git svn dcommit'
alias rename='git branch -m'
alias branch='clear; git branch -vv'
alias master='git checkout master'
alias status='clear; git branch -vv; git status'
alias czk='git checkout'
alias track='git branch --set-upstream-to'
alias commit='git add -A; git commit'
alias commend='git add -A; git commit --amend'
alias herokify='git push heroku'
alias glog='git lg'
# git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias hdiff='clear; git diff HEAD^ HEAD --color-words'
alias ipad='/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone\ Simulator.app/Contents/MacOS/iPhone\ Simulator -SimulateApplication /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator7.1.sdk/Applications/MobileSafari.app/MobileSafari'
alias vimw='cd ~/git/webapp; vim -c NJ -c TNT -c TNL -c TNI -c TNA -c tabn'
alias nerd='vim -c Nerd'
source ~/git-completion.bash
export TERM='xterm-256color'
# Automatically add completion for all aliases to commands having completion functions
function alias_completion {
    local namespace="alias_completion"

    # parse function based completion definitions, where capture group 2 => function and 3 => trigger
    local compl_regex='complete( +[^ ]+)* -F ([^ ]+) ("[^"]+"|[^ ]+)'
    # parse alias definitions, where capture group 1 => trigger, 2 => command, 3 => command arguments
    local alias_regex="alias ([^=]+)='(\"[^\"]+\"|[^ ]+)(( +[^ ]+)*)'"

    # create array of function completion triggers, keeping multi-word triggers together
    eval "local completions=($(complete -p | sed -Ene "/$compl_regex/s//'\3'/p"))"
    (( ${#completions[@]} == 0 )) && return 0

    # create temporary file for wrapper functions and completions
    rm -f "/tmp/${namespace}-*.tmp" # preliminary cleanup
    local tmp_file="$(mktemp "/tmp/${namespace}-${RANDOM}.tmp")" || return 1

    # read in "<alias> '<aliased command>' '<command args>'" lines from defined aliases
    local line; while read line; do
        eval "local alias_tokens=($line)" 2>/dev/null || continue # some alias arg patterns cause an eval parse error 
        local alias_name="${alias_tokens[0]}" alias_cmd="${alias_tokens[1]}" alias_args="${alias_tokens[2]# }"

        # skip aliases to pipes, boolan control structures and other command lists
        # (leveraging that eval errs out if $alias_args contains unquoted shell metacharacters)
        eval "local alias_arg_words=($alias_args)" 2>/dev/null || continue

        # skip alias if there is no completion function triggered by the aliased command
        [[ " ${completions[*]} " =~ " $alias_cmd " ]] || continue
        local new_completion="$(complete -p "$alias_cmd")"

        # create a wrapper inserting the alias arguments if any
        if [[ -n $alias_args ]]; then
            local compl_func="${new_completion/#* -F /}"; compl_func="${compl_func%% *}"
            # avoid recursive call loops by ignoring our own functions
            if [[ "${compl_func#_$namespace::}" == $compl_func ]]; then
                local compl_wrapper="_${namespace}::${alias_name}"
                    echo "function $compl_wrapper {
                        (( COMP_CWORD += ${#alias_arg_words[@]} ))
                        COMP_WORDS=($alias_cmd $alias_args \${COMP_WORDS[@]:1})
                        $compl_func
                    }" >> "$tmp_file"
                    new_completion="${new_completion/ -F $compl_func / -F $compl_wrapper }"
            fi
        fi

        # replace completion trigger by alias
        new_completion="${new_completion% *} $alias_name"
        echo "$new_completion" >> "$tmp_file"
    done < <(alias -p | sed -Ene "s/$alias_regex/\1 '\2' '\3'/p")
    source "$tmp_file" && rm -f "$tmp_file"
}; alias_completion
