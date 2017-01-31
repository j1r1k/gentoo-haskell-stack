# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit haskell-stack

DESCRIPTION="Functional Programming Language with Dependent Types"
HOMEPAGE="http://www.idris-lang.org/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="ffi gmp"

RESTRICT=test # pulls stack

RDEPEND="dev-haskell/stack-bin:="
DEPEND="${RDEPEND}"

src_prepare() {
  default
  estack setup || die
}

src_compile() {
  estack install \
  	$(stack_flag idris ffi) \
  	$(stack_flag idris gmp) || die
}

src_install() {
  dobin "${HOME}/.local/bin/idris"
  dobin "${HOME}/.local/bin/idris-codegen-c"
  dobin "${HOME}/.local/bin/idris-codegen-javascript"
  dobin "${HOME}/.local/bin/idris-codegen-node"
  doman man/${PN}.1
}
