BREW_DEPS?=antigen fzf yq jq

ANTIGEN_CONFIG_PATH=~/.antigenrc
ANTIGEN_CONFIG_BACKUP_PATH=$(ANTIGEN_CONFIG_PATH)_$(shell date "+%Y-%m-%d_%H-%M-%S").bak

ZSH_CONFIG_PATH?=~/.zshrc
ZSH_CONFIG_BACKUP_PATH?=$(ZSH_CONFIG_PATH)_$(shell date "+%Y-%m-%d_%H-%M-%S").bak

GIT_CONFIG_PATH?=~/.gitconfig
GIT_CONFIG_BACKUP_PATH?=$(GIT_CONFIG_PATH)_$(shell date "+%Y-%m-%d_%H-%M-%S").bak

GITIGNORE_PATH?=~/.gitignore_global
GITIGNORE_BACKUP_PATH?=$(GITIGNORE_PATH)_$(shell date "+%Y-%m-%d_%H-%M-%S").bak

BREW=$(shell which brew)

.PHONY: brew brew-deps nvm antigen-ln zsh-ln git-ln

brew:
	which -s brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew-deps: brew
	brew update
	brew upgrade
	brew install $(BREW_DEPS)

nvm:
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

antigen-ln:
	[[ -f $(ANTIGEN_CONFIG_PATH) ]] && mv $(ANTIGEN_CONFIG_PATH) $(ANTIGEN_CONFIG_BACKUP_PATH) || true
	ln -s $(shell pwd)/.antigenrc $(ANTIGEN_CONFIG_PATH)

zsh-ln:
	[[ -f $(ZSH_CONFIG_PATH) ]] && mv $(ZSH_CONFIG_PATH) $(ZSH_CONFIG_BACKUP_PATH) || true
	ln -s $(shell pwd)/.zshrc $(ZSH_CONFIG_PATH)

git-ln:
	[[ -f $(GIT_CONFIG_PATH) ]] && mv $(GIT_CONFIG_PATH) $(GIT_CONFIG_BACKUP_PATH) || true
	ln -s $(shell pwd)/.gitconfig $(GIT_CONFIG_PATH)

	[[ -f $(GITIGNORE_PATH) ]] && mv $(GITIGNORE_PATH) $(GITIGNORE_BACKUP_PATH) || true
	ln -s $(shell pwd)/.gitignore_global $(GITIGNORE_PATH)
