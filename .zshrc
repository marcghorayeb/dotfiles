# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Consider certain characters as word separators (especially /)
autoload -U select-word-style
select-word-style bash

# Enable autocompletions
autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)

if [ $(date +'%j') != $updated_at ]; then
	compinit -i
else
	compinit -C -i
fi

zmodload -i zsh/complist

# Antigen bundles
source /usr/local/share/antigen/antigen.zsh # this line comes from the brew installation log
antigen init ~/.antigenrc

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Enable fzf (history fuzzy finder Ctrl+R)
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# Enable SSH keys from GPG
SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

# Terminal history options
HISTSIZE=100000
SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks # remove superfluous blanks from history items
setopt inc_append_history # save history entries as soon as they are entered
setopt share_history # share history between different instances of the shell

# Search history with up/down arrows (requires zsh-history-substring-search)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Autocomplete configuration
setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion

zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

alias ll="ls -alhG"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

it2prof() {
    echo -e "\033]50;SetProfile=$1\a"
}

dark() {
    it2prof Dark
}

light() {
    it2prof Light
}

# Host filtering

FILTERED_HOSTS_URL=https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts
HOSTS_OUT=/etc/hosts

hosts-filter-update() {
    sudo curl ${FILTERED_HOSTS_URL} -o ${HOSTS_OUT} && dns-reset
}

dns-reset() {
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
}

setup-secrets() {
    # export NPM_TOKEN=
    # export VAULT_ADDR=

    # export DOCKER_USERNAME=
    # export DOCKER_PASSWORD=
    # export DOCKER_EMAIL=
}

# Work alias
# -o UserKnownHostsFile=/Users/marcghorayeb/Library/Containers/com.sequel-ace.sequel-ace/Data/.keys/ssh_known_hosts_strict \
alias db-proxy="ssh \
    -v \
    -N \
    -S none \
    -o ControlMaster=no \
    -o ExitOnForwardFailure=yes \
    -o ConnectTimeout=10 \
    -o NumberOfPasswordPrompts=3 \
    -o TCPKeepAlive=no \
    -o ServerAliveInterval=60 \
    -o ServerAliveCountMax=1 \
    ec2-user@devweb.vpng.io \
    -L 3306:internal.host:3306"

setup-env() {
    # export FIRSTNAME=marc
    # export LASTNAME=ghorayeb

    # export KUBE_CONFIG=~/.kube/config
    # export KUBE_NS=marc # your username, do *not* use "default" on remote clusters)
    # export KUBE_DOCKER_SECRET=quay

    setup-secrets
}

# kube-cluster-setup() {
#     setup-env

#     kubectl create ns $KUBE_NS
#     kubectl config set-context --current --namespace=$KUBE_NS

#     kubectl delete secret $KUBE_DOCKER_SECRET
#     kubectl create secret docker-registry $KUBE_DOCKER_SECRET \
#         --docker-server=$DOCKER_REGISTRY \
#         --docker-username=$DOCKER_USERNAME \
#         --docker-password=$DOCKER_PASSWORD \
#         --docker-email=$DOCKER_EMAIL
# }

# vault-login() {
#     setup-env
#     vault login -method=userpass username=${FIRSTNAME}.${LASTNAME}
# }

# vault-get-kubeconfig() {
#     setup-env
#     vault kv get -field "data" -format yaml secret/kubernetes/kubeconfigs/${FIRSTNAME}.${LASTNAME} > $KUBE_CONFIG
# }
