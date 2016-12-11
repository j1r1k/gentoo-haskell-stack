# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit haskell-stack
STACK_RESOLVER="lts-3.20"

DESCRIPTION="merge bash_history utility"
HOMEPAGE="https://github.com/j1r1k/merge-bash-history#readme"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-haskell/stack-bin:= "
DEPEND="${RDEPEND}"

src_prepare() {
    default
	estack_init || die
    estack setup || die
}

src_compile() {
    estack_install || die
}

src_install() {
    dobin "${T}/bin/merge-bash-history"
}
