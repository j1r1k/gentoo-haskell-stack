# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit haskell-stack
STACK_RESOLVER="nightly-2016-10-31"

DESCRIPTION="A static website compiler library"
HOMEPAGE="http://jaspervdj.be/hakyll"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+checkexternal +previewserver +watchserver"

RESTRICT=test # missing file

RDEPEND="dev-haskell/stack-bin:="
DEPEND="${RDEPEND}"

src_prepare() {
    default
    estack_init || die
    estack setup || die
}

src_compile() {
    estack_install \
        $(stack_flag hakyll checkexternal checkexternal) \
        $(stack_flag hakyll previewserver previewserver) \
        $(stack_flag hakyll watchserver watchserver) || die
}

src_install() {
    dobin "${T}/bin/hakyll-init"
}
