# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Consider certain characters as word separators (especially /)
autoload -U select-word-style
select-word-style bash

# Enable autocompletions
autoload -Uz compinit
if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ${ZDOTDIR:-$HOME}/.zcompdump) ]; then
	compinit
else
	compinit -C
fi

zmodload -i zsh/complist

# Antigen bundles

source $(brew --prefix)/share/antigen/antigen.zsh                                 # this path comes from the brew installation log, can be different on Mac M1
antigen init ~/.antigenrc

. $(brew --prefix asdf)/libexec/asdf.sh

_evalcache direnv hook zsh                                                  # Equivalent to `eval "$(direnv hook zsh)"`, but with caching, thanks to mroth/evalcache
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh                                  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.

export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh                                    # Enable fzf (history fuzzy finder Ctrl+R)

# Enable SSH keys from GPG
SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
pgrep -q -u $USER gpg-agent || gpgconf --launch gpg-agent

# Terminal history options
HISTSIZE=100000
SAVEHIST=$HISTSIZE

setopt hist_ignore_all_dups                                                 # remove older duplicate entries from history
setopt hist_reduce_blanks                                                   # remove superfluous blanks from history items
setopt inc_append_history                                                   # save history entries as soon as they are entered
setopt share_history                                                        # share history between different instances of the shell

# Search history with up/down arrows (requires zsh-history-substring-search)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Autocomplete configuration
setopt auto_list                                                            # automatically list choices on ambiguous completion
setopt auto_menu                                                            # automatically use menu completion

zstyle ':completion:*' menu select                                          # select completions with arrow keys
zstyle ':completion:*' group-name ''                                        # group results by category
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

zstyle ':fzf-tab:*' default-color $'\033[33m'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

# alias ll="ls -alhG"
alias ll="exa -alh"

fpath=($fpath ~/.zsh_autoload)
autoload -Uz it2prof dark light dns-reset hosts-filter-update

alias aws-qa="aws --profile=qa"
alias aws-staging="aws --profile=staging"
alias aws-prod="aws --profile=production"

# alias prof-zsh-startup="for i in $(seq 1 10); do /usr/bin/time zsh -i -c exit; done"

export PNPM_HOME="/Users/marcghorayeb/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
