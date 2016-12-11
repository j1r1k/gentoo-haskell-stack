# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit haskell-stack elisp-common

DESCRIPTION="Source code suggestions"
HOMEPAGE="https://github.com/ndmitchell/hlint#readme"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="emacs +gpl"

RDEPEND="dev-haskell/stack-bin:="
DEPEND="${RDEPEND}"

SITEFILE="60${PN}-gentoo.el"

src_prepare() {
	default
	estack_init || die
	estack setup || die
}

src_compile() {
	estack_install \
		$(stack_flag hlint gpl) || die

	use emacs && elisp-compile data/hs-lint.el
}

src_install() {
	dobin "${T}/bin/hlint"

	if use emacs; then
		elisp-install ${PN} data/*.el data/*.elc || die "elisp-install failed."
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	doman data/hlint.1
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
