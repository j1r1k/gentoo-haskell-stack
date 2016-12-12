# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit haskell-stack

DESCRIPTION="Hackage and Portage integration tool"
HOMEPAGE="http://hackage.haskell.org/package/hackport"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT=test # tests are broken: need path to ebuild tree

RDEPEND="dev-haskell/stack-bin:="
DEPEND="${RDEPEND}"

src_prepare() {
    default
    estack_init --ignore-subdirs || die
    estack setup || die
}

src_compile() {
    estack_install || die
}

src_install() {
    dobin "${T}/bin/hackport"
    doman man/hackport.1
}
