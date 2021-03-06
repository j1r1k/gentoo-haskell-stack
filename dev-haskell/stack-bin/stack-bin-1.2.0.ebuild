# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit bash-completion-r1

# ebuild generated by hackport 0.4.5.9999

DESCRIPTION="The Haskell Tool Stack"

HOMEPAGE="https://github.com/commercialhaskell/stack"

SRC_URI="amd64? ( https://github.com/commercialhaskell/stack/releases/download/v${PV}/stack-${PV}-linux-x86_64.tar.gz ) \
         x86? ( https://github.com/commercialhaskell/stack/releases/download/v${PV}/stack-${PV}-linux-i386.tar.gz )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND="
    >=dev-lang/perl-5.6.1
    dev-libs/gmp:0=
    sys-libs/ncurses:=[tinfo,unicode]
    virtual/libffi:=
"

DEPEND="${RDEPEND}"

src_unpack() {
    default_src_unpack
    mv -i "${WORKDIR}/stack-${PV}-"* "${WORKDIR}/${PN}-${PV}" || die "Cannot rename source directory"
}

src_install() {
    dobin "stack"

    ./stack --bash-completion-script stack > "${T}/bashcomp" || die "Failed to generate bash-completion script"

    newbashcomp "${T}/bashcomp" "stack"

    if use doc; then
        dodoc "${S}/doc/*"
    fi
}
