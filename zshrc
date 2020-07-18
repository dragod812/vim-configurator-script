# Setup environment variables

export JAVA_HOME="$(/usr/libexec/java_home -v1.8)"
export ANDROID_HOME=~/android-sdk
export ANDROID_NDK=~/android-ndk
export ANDROID_NDK_HOME=~/android-ndk
export VISUAL=vim
export EDITOR="$VISUAL"
export GOPATH=/Users/sidharthpadhee/gocode

# Add env vars to PATH
export PATH=$JAVA_HOME/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools/bin:$PATH
export PATH="/usr/local/go/bin:$PATH"


# Enable colors and change prompt:
autoload -U colors && colors

# Git prompt
source ~/.config/git-prompt.sh

setopt PROMPT_SUBST ;
PS1=$'\n'"%B%{$fg[red]%}[ %{$fg[magenta]%}%c%{$fg[green]%} $(__git_ps1 '| %s ')]%{$reset_color%}$%b "
# PS1='[%n@%m %c$(__git_ps1 " (%s)")]\$ '

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v

# reverse search binding
bindkey '^R' history-incremental-search-backward

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Git Aliases
alias adh='arc diff HEAD~1'
alias adhu='arc diff HEAD~1 --update'
alias gb='git branch'
alias gc=__gitCheckout
function __gitCheckout() {
	if [ "$1" != "" ]
	then
		branch=`git branch | sed -e 's/^[ \t]*//' | sed -n $1p`;
		git checkout $branch
		rf
	else
		git branch | nl
	fi
}
alias cb="git rev-parse --abbrev-ref HEAD"
alias cpcb="git rev-parse --abbrev-ref HEAD | tr -d '\n' | pbcopy"
alias grim='git rebase -i master'
alias grc='git rebase --continue'
alias gca='git commit --amend'
alias gsl='git stash list'
alias gss=__gitStashShow
function __gitStashShow() {
	if [ "$1" != "" ]
	then
		git stash show -p stash@{$1}
	else
		git stash show -p
	fi
}
alias gsa=__gitStashApply
function __gitStashApply() {
	if [ "$1" != "" ]
	then
		git stash apply stash@{$1}
	else
		git stash apply
	fi
}
alias gu=__gu
function __gu() {
	branch=`git rev-parse --abbrev-ref HEAD`;
	git checkout master && git pull origin && git checkout $branch && git rebase master;
}
alias commitCount='grep -c ^ <(gl)'
alias admr='arc diff -m "rebase"'
alias rebaseLoop=__rebaseLoop
function __rebaseLoop() {
	COUNT=0
	if [ -n "$1" ]; then
		COUNT=$1
	else
		COUNT=100
	fi

	echo "Rebasing up to $COUNT diffs.";

	for ((i=1; i<=$COUNT; i++ )); do
		if admr
	    	then
	    	echo "Rebased $i successfully"
	    	grc
	    else
    		echo "Error rebasing $i, exiting"
    		break
		fi
	done
}

# aliases
alias rf="source ~/.zshrc"
alias edit="mvim -v"
alias notes="edit /Users/sidharthpadhee/.vim/bundle/vim-notes/misc/notes/user"
alias cd-cp="cd ~/go-code/src/code.uber.internal/money/checkout/checkout-presentation"
alias run-cp="UBER_CONFIG_DIR=src/code.uber.internal/money/checkout/checkout-presentation/config bazel run //src/code.uber.internal/money/checkout/checkout-presentation:checkout-presentation"
alias build-cp="bazel build //src/code.uber.internal/money/checkout/checkout-presentation:checkout-presentation"
alias ied="~/Uber/android/buckw install eatsDebug --run"
alias iee="~/Uber/android/buckw install eatsExo --run"
alias pee="~/Uber/android/buckw project eatsExo"
alias af=__arcFlow
function __arcFlow() {
	if [ "$1" != "" ]
	then
		arc flow $1
		rf
	else
		arc flow
	fi
}
alias android-commit="~/Uber/android/tooling/shell/gjf-on-diff.sh"
alias list-ports="lsof -nP +c 15 | grep LISTEN"
alias list-adhoc='lzc host list -n "adhoc*" --format="{{.Hostname}}"'
alias f="find . -iname"
alias em="emulator -avd test-em"


# direnv
eval "$(direnv hook zsh)"

# Load zsh-syntax-highlighting; should be last.
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null


