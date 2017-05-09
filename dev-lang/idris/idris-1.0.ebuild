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
  export IDRIS_LIB_DIR="/usr/share/idris"
  estack install \
    --flag idris:freestanding \
    $(stack_flag idris ffi) \
    $(stack_flag idris gmp) || die

  LOCAL_INSTALL_ROOT=$(estack path --local-install-root)
  GHC_VERSION=$(estack ghc -- --version | sed -n 's~^.*version \([[:digit:].]*$\)~\1~p')
  ARCH=$(uname -m)
  KNAME=$(uname | tr '[:upper:]' '[:lower:]')
  ln -s "${LOCAL_INSTALL_ROOT}/share/${ARCH}-${KNAME}-ghc-${GHC_VERSION}/${PN}-${PV}" ".stack-share"
}

src_install() {
  exeinto /usr/lib/idris
  doexe "${HOME}/.local/bin/idris"
  doexe "${HOME}/.local/bin/idris-codegen-c"
  doexe "${HOME}/.local/bin/idris-codegen-javascript"
  doexe "${HOME}/.local/bin/idris-codegen-node"

  dosym "/usr/lib/idris/idris" "/usr/bin/idris"
  dosym "/usr/lib/idris/idris-codegen-c" "/usr/bin/idris-codegen-c"
  dosym "/usr/lib/idris/idris-codegen-javascript" "/usr/bin/idris-codegen-javascript"
  dosym "/usr/lib/idris/idris-codegen-node" "/usr/bin/idris-codegen-node"

  insinto /usr/lib/idris/libs
  doins -r ".stack-share/docs"
  doins -r ".stack-share/idrisdoc"
  doins -r ".stack-share/jsrts"
  doins -r ".stack-share/libs"
  doins -r ".stack-share/rts"

  doman "man/${PN}.1"
}
