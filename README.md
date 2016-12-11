# Gentoo Haskell Stack Overlay

Gentoo overlay for installing haskell software via [stack](https://www.haskellstack.org)

## Why

Gentoo's approach to installing haskell software is rare among linux distribution landscape. It involves building each dependency as portage package and registering it in global ghc-pkg registry.

This has two major consequences:
- If you install enough haskell packages, you will discover a conflict that cannot be solved
- If you are developing in haskell, you have to ignore global packages store somehow

Every haskell library or program has a unique set of dependencies. Possibly requiring different version of ghc as well. Stack is here to help.

## Known issues

- `stack.yaml` is usually not bundled in the hackage dist package (see #1)

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
## Configuration

### Portage ENV variables

- `$STACK_RESOLVER` - stack resolver to be used when running `stack init` inside the build

## Important notes

- `stack` is distributed as binary.
- `haskell-stack.eclass` is very rough with plenty of TODO
- `stack` has `stack-root` set to `/var/tmp/portage/.stack` in order to share downloads in between builds

## Contents of this overlay

Most importantly:
- `dev-haskell/stack-bin` - binary distribution of stack

Otherwise:
- I am adding packages as I need them. I am basing ebuilds on ebuilds from [gentoo-haskell/gentoo-haskell](https://github.com/gentoo-haskell/gentoo-haskell)


## Discalmer
This is just a proof of concept project. I would love to see this approach more adopted, please feel free to contact me/contribute/fork.
