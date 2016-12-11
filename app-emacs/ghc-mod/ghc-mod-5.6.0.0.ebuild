# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit haskell-stack elisp-common

DESCRIPTION="Happy Haskell Programming"
HOMEPAGE="http://www.mew.org/~kazu/proj/ghc-mod/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="emacs"

RESTRICT=test

RDEPEND="dev-haskell/stack-bin:="
DEPEND="${RDEPEND}"
SITEFILE=50${PN}-gentoo.el

src_prepare() {
    default
    epatch "${FILESDIR}"/${PN}-5.6.0.0-gentoo.patch
	estack_init --ignore-subdirs|| die
    estack setup || die
}

src_compile() {
    estack_install || die

    if use emacs ; then
        pushd elisp
        elisp-compile *.el || die
        popd
    fi
}

src_install() {
    dobin "${T}/bin/ghc-mod"

    if use emacs ; then
        pushd "${S}"
        elisp-install ghc-mod elisp/*.{el,elc}
        elisp-site-file-install "${FILESDIR}"/${SITEFILE}
        popd
    fi
}

pkg_postinst() {
    if use emacs ; then
        elisp-site-regen
        elog "To configure ghc-mod either add this line to ~/.emacs:"
        elog "(autoload 'ghc-init \"ghc\" nil t)"
        elog "and either this line:"
        elog "(add-hook 'haskell-mode-hook (lambda () (ghc-init)))"
        elog "or if you wish to use flymake:"
        elog "(add-hook 'haskell-mode-hook (lambda () (ghc-init) (flymake-mode)))"
    fi
}

pkg_postrm() {
    if use emacs ; then
        elisp-site-regen
    fi
}
