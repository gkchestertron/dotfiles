alias sub='open -a "Sublime Text"'
alias serve='open http://localhost:8000 && python -m SimpleHTTPServer'
alias arcpatchshitfuck='git branch | grep "arcpatch" | xargs git branch -D'
alias approve='git stash apply stash^{/UserSession}'
alias unapprove='git stash show -p stash^{/UserSession} | git apply -R'
alias gdiff='git diff --color=always | less -r'
alias masterbase='git rebase master'
alias work='cd ~/svn/Development/trunk/'
alias fml='cd ~/Desktop/CVR_CA/CIS/cvr.common.cis.webapi/src/'
alias ets='cd ~/ets/'
alias shitfuck='cd ~/projects/'
alias ngrok='~/ngrok 3000'
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
alias hdiff='clear; git diff HEAD^ HEAD --color-words'
alias ipad='/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone\ Simulator.app/Contents/MacOS/iPhone\ Simulator -SimulateApplication /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator7.1.sdk/Applications/MobileSafari.app/MobileSafari -u "https://testapp.avrs.com/v2/"'
alias avrs='cd ~/AVRS/'
alias rust='cd ~/shitFuck/rust/'
alias minions='cd ~/shitFuck/assemble/'
alias vimc='vi -p `{ git diff-tree --no-commit-id --name-status -r HEAD | grep ^[^D] | cut -f2; git status --porcelain | cut -c4-; } | sort | uniq`'
alias vimf='vim -c NJ -c TNT -c TNL -c TNI -c TNA -c tabn'
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

hipchat () {
    echo "{ \"message\": \"${1}\", \"message_format\": \"text\", \"color\": \"purple\", \"notify\": true }" | curl -d @- https://api.hipchat.com/v2/room/106666/notification?auth_token=somenewtoken --header "content-type: application/json"
}
getdiffmessage () { 
    OUTPUT="$(git log -1)"
    echo "${OUTPUT}" | grep 'Reviewers' | cut -d ':' -f2 | awk '{for(i=1;i<NF+1;i++){printf "@"$i" " }}'
    echo "${OUTPUT}" | grep 'Revision' | awk '{ print $3 }'
    echo " $(git log -1 --pretty=%s)"
}
hipdiff () {
    MESSAGE="$(getdiffmessage)"
    hipchat "${MESSAGE} - ${1}"
}
hiptest () {
    echo "${1}"
}

gitfuck () {
    git branch --merged | grep "${1}" | xargs git branch -D
}
export PATH="/usr/local/mysql/bin:$PATH"
