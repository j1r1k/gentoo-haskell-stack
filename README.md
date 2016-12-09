# Gentoo Haskell Stack Overlay

Gentoo overlay for installing haskell software via `stack`

## Why

Gentoo's approach to installing haskell software is rare among linux distribution landscape. It involves building each dependency as portage package and registering it in global ghc-pkg registry.

This has two major consequences:
- If you install enough haskell packages, you will discover a conflict that cannot be solved
- If you are developing in haskell, you have to ignore global packages store somehow

Every haskell library or program has a unique set of dependencies. Possibly requiring different version of ghc as well. Stack is here to help.

## How to use it

Please amend `location` and `priority` to suit your needs.

```bash
cat >/etc/portage/repos.conf/haskell-stack <<EOF
[haskell-stack]
location = /usr/portage/haskell-stack
sync-type = git
sync-uri = git://github.com/j1r1k/gentoo-haskell-stack.git
priority = 0
EOF
```

## Important notes

- `stack` is distributed as binary.
- `haskell-stack.eclass` is very rough with plenty of TODO
- `stack` has `stack-root` set to `/var/tmp/portage/.stack` in order to share downloads in between builds

## Contents of this overlay

There are currently only two packages (to test this approach)
- `dev-haskell/stack-bin` - binary distribution of stack
- `dev-vcs/git-annex` - git file manager with plenty of dependencies in gentoo or gentoo-haskell 

## Discalmer
This is just a proof of concept project. I would love to see this approach more adopted, please feel free to contact me/contribute/fork.
