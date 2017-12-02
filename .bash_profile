source ~/git-completion.bash

set -o vi

# checkout branch by grep basically
gk () {
  match="$1"
  index=$2
  if [ -z $match ]
  then
    echo please provide a string to match for branch checkout - also pass index if multiple exist
    return
  fi

  local_matches=(`git branch | sed -E 's/(\* |  )//' | grep $match | sort -u`)
  matches=(`git branch -a | sed -E 's/(\* |  |  remotes\/(origin|upstream)\/)//' | grep $match | sort -u`)

  # if master checkout master
  if [ $match = "master" ]
  then
    git checkout master

  # checkout if only one local match
  elif [ "${#local_matches[@]}" -eq 1 ]
  then
    git checkout ${local_matches[0]}

  # checkout if only one match
  elif [ "${#matches[@]}" -eq 1 ]
  then
    git checkout ${matches[0]}

  # checkout by index if given
  elif [ ! -z "$index" ]
  then
    git checkout ${matches[$index]}

  # else 
  else
    for ((i=0; i<${#matches[@]};i++))
    do
      echo ${matches[$i]}
    done
  fi
}

# reload chrome
rechrome () {
  osascript -e 'activate application "Google Chrome"'
  osascript -e 'tell application "System Events" to keystroke "r" using {command down}'
}

# open a node stack trace in vim
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

dev () {
  tab gogo-dev
}

tab () {
  osascript 2>/dev/null <<EOF
    tell application "System Events"
      tell process "Terminal" to keystroke "t" using command down
    end
    tell application "Terminal"
      activate
      do script with command "cd \"$PWD\"; $*" in window 1
    end tell
EOF
}

# open all the changed files in the working tree
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

# spin up ember server with live dev backend
live-dev () {
  # default to TYTHON Tunnel server - prob change this when I figure out what it is I do here
  server="0361"
  port="$2"

  # use first arg if given
  if [ ! -z "$1" ]
  then
    server="$1"

  # use env var if not empty
  elif [ ! -z $BP_HOSTNAME ]
  then
    server="$BP_HOSTNAME"
  fi

  # if we just passed a num assume normal test server format
  if [ ${#server} -le 4 ]
  then
    server="onxv$server.ott.ciena.com"
  fi

  # serve it up with live dev back end
  if [ -z $port ]
  then
    port="4300"
  fi

  ember s -e live-dev --proxy "https://$server" --secure-proxy=false --port=$port --live-reload-port="$port"1
}

# serves README or specified file and opens it in the browser
gread () {
  open "http://localhost:6419"
  grip "$1"
}

# starts up watchman-processor, sets remote box working dir, and logs into screen session
gogo-dev () {
  cdir=$(pwd | sed s/^.*dev\\///)
  echo starting watchman-processor...
  echo see ~/.watchman-processor.config.js for details
  echo
  watchman-processor &>/dev/null &
  disown

  echo setting screen windows to match current working dir
  echo
  ssh dev -t "screen -x -p local -X stuff '^C cd ~/dev/$cdir \r'"
  ssh dev -t "screen -x -p live-dev -X stuff '^C cd ~/dev/$cdir \r'"
  ssh dev -t "screen -x -p tests -X stuff '^C cd ~/dev/$cdir \r'"

  echo logging into screen session on dev box
  echo start session on target machine if this fails
  echo
  ssh dev -t "screen -x -p local"

  echo killing watchman-processor...
  pgrep watchman-processor | xargs kill -9
  exit
}

# merge in latest master brance (I know mastermerge would be more accurate, but less funny)
masterbase () {
  git stash
  branch=`git branch | grep '*' | awk '{print $(NF)}'`
  git checkout master
  git pull
  git checkout $branch
  git merge master
  git stash apply
}

# Git branch in prompt.

parse_git_branch() {
  branch=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'`
  BPSO=`echo $branch | grep -oE 'BPSO-\d+'`

	if [ -z $branch ]
  then
    echo " "
  elif [ -z $BPSO ]
  then
    echo "$branch "
  else
    echo " ($BPSO) "
  fi
}

export PS1="\[\033[32m\]\u@$(echo $HOSTNAME | sed 's/-.*$//'):\[\033[00m\]\w\[\033[32m\]\$(parse_git_branch)\[\033[00m\]$ "

alias postgresser='postgres -D /usr/local/var/postgres'
alias crosscomp='export PATH="$HOME/opt/cross/bin:$PATH"'
alias woodshop='cd ~/woodshop/'
alias work='cd ~/dev/'
alias mycom='sudo /Library/StartupItems/MySQLCOM/MySQLCOM'
alias mampdocs='cd /Applications/MAMP/htdocs/'
alias pyserv='python -m SimpleHTTPServer & open http://localhost:8000'
alias sub='open -a "Sublime Text"'
alias phpserv='sudo apachectl -d $PWD -k start && open http://localhost'
alias phpstop='sudo apachectl -d $PWD -k stop'
alias gdiff='git diff --color=always | less -r'
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
export TERM='xterm-256color'

platform=`uname`
if [ "$platform" != "Linux" ]
then
  for f in /etc/bash_completion.d/*; do source $f; done

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
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source ~/notes/notes
