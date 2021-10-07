# dotfiles

## About SSH/GPG

1. Import all your keys into GPG
1. Make sure `enable-ssh-support` is added to `~/.gnupg/gpg-agent.conf`
1. Add your keygrip to `~/.gnupg/sshcontrol`

__Note__: Keygrips can be found through the `gpg -K --with-keygrip` command

### Useful links

- https://opensource.com/article/19/4/gpg-subkeys-ssh
- https://gregrs-uk.github.io/2018-08-06/gpg-key-ssh-mac-debian/
- https://www.linode.com/docs/guides/gpg-key-for-ssh-authentication/#serve-your-gpg-key-instead-of-an-ssh-key

## About Git/GPG

Signing keys for git can be found with `gpg --list-secret-keys --keyid-format=long`.
