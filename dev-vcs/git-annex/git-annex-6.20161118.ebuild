# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# based on https://github.com/gentoo-haskell/gentoo-haskell/blob/master/dev-vcs/git-annex/git-annex-6.20161118.ebuild

EAPI=6
inherit haskell-stack

DESCRIPTION="manage files with git, without checking their contents into git"
HOMEPAGE="http://git-annex.branchable.com/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"
RESTRICT="test"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="assistant benchmark +concurrentoutput +cryptonite doc +dbus +magicmime +network-uri +pairing s3 -test torrentparser webapp webdav xmpp"

RDEPEND="dev-haskell/stack-bin:=
    assistant? ( sys-process/lsof )
    dev-vcs/git
"

DEPEND="${RDEPEND}
    dev-lang/perl
    doc? ( www-apps/ikiwiki net-misc/rsync )
"

src_prepare() {
    default_src_prepare
    estack setup || die
}

src_test() {
    if use webapp; then
        export GIT_CONFIG=${T}/temp-git-config
        git config user.email "git@src_test"
        git config user.name "Mr. ${P} The Test"

        emake test
    fi
}

src_compile() {
    estack_install \
        --flag git-annex:-android \
        --flag git-annex:-androidsplice \
        $(stack_flag git-annex benchmark) \
        $(stack_flag git-annex concurrentoutput) \
        $(stack_flag git-annex cryptonite) \
        $(stack_flag git-annex dbus) \
        $(stack_flag git-annex magicmime) \
        $(stack_flag git-annex network-uri) \
        $(stack_flag git-annex pairing) \
        --flag git-annex:production \
        $(stack_flag git-annex s3) \
        $(stack_flag git-annex test testsuite) \
        $(stack_flag git-annex torrentparser) \
        $(stack_flag git-annex webapp) \
        $(stack_flag git-annex webdav) \
        $(stack_flag git-annex xmpp) || die
}

src_install() {
    newbashcomp "${FILESDIR}"/${PN}.bash ${PN}

    dobin "${T}/bin/git-annex"

    dodoc CHANGELOG README
    if use webapp ; then
        doicon "${FILESDIR}"/${PN}.xpm
        make_desktop_entry "${PN} webapp" "git-annex" ${PN}.xpm "Office"
    fi
}
