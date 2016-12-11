# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit haskell-stack
STACK_RESOLVER="lts-5.5"

MY_PN="ShellCheck"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Shell script analysis tool"
HOMEPAGE="http://www.shellcheck.net/"
SRC_URI="mirror://hackage/packages/archive/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-haskell/stack-bin:="
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
    default
	estack_init || die
    estack setup || die
}

src_compile() {
    estack_install || die
}

src_install() {
    dobin "${T}/bin/shellcheck"
    doman "${PN}.1"
}
