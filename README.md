# dotfiles

## About SSH/GPG

1. Import all your keys into GPG
1. Make sure `enable-ssh-support` is added to `~/.gnupg/gpg-agent.conf`
1. Add your keygrip to `~/.gnupg/sshcontrol`

__Note__: Keygrips can be found through the `gpg -K --with-keygrip` command

## About Git/GPG

Signing keys for git can be found with `gpg --list-secret-keys --keyid-format=long`.
