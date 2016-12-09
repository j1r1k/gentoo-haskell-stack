# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: stack.eclass
# @MAINTAINER:
# @AUTHOR:
# @BLURB: for packages that make use of the stack
# @DESCRIPTION:
# TODO

inherit eutils

# @FUNCTION: estack
# @DESCRIPTION:
# stack wrapper that is using stack-root in home directory of portage user
# TODO
estack() {
    stack --stack-root="$(getent passwd portage | cut -d: -f6)/.stack" "${@}"
}

# @FUNCTION: estack
# @DESCRIPTION:
# estack wrapper that installs binaries in \${T}/bin
# TODO
estack_install() {
    mkdir -p "${T}/bin"
    estack install --local-bin-path "${T}/bin" "${@}"
}

# @FUNCTION: stack_flag
# @DESCRIPTION:
# haskell-cabal.eclass:cabal_flag() taken as base
#
# Usage examples:
#
#     stack_flag git-annex dbus
#  leads to "--flag git-annex:dbus" or "--flag git-annex:-dbus" (useflag 'dbus')
#
#     stack_flag git-annex test testsuite
#  also leads to "--flag git-annex:testsuite" or " --flag git-annex:-testsuite" (useflag 'test')
#
stack_flag() {
    if [[ $# -lt 2 ]] || [[ $# -gt 3 ]]; then
        echo "!!! stack_flag() called without a parameter." >&2
        echo "!!! stack_flag() <PKGNAME> <USEFLAG> [<stack_flagname>]" >&2
        return 1
    fi

    local UWORD=${3:-$2}

    usex "${2}" "--flag ${1}:${UWORD}" "--flag ${1}:-${UWORD}"
}
