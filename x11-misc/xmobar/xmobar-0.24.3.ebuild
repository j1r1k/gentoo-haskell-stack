# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit haskell-stack
STACK_RESOLVER="lts-4.1"

DESCRIPTION="A Minimalistic Text Based Status Bar"
HOMEPAGE="http://xmobar.org"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa dbus inotify mpd mpris timezone wifi with_conduit with_uvmeter xft xpm"

RDEPEND="dev-haskell/stack-bin:=
    x11-libs/libXrandr
    x11-libs/libXrender
    wifi? ( net-wireless/wireless-tools )
    xpm? ( x11-libs/libXpm )
"
DEPEND="${RDEPEND}"

PATCHES=(
    "${FILESDIR}"/${P}-noxpm.patch
    )

src_prepare() {
    default
    # xmobar is an idle multithreaded program
    # which sits in 'while { sleep(1); }'
    # loops in multiple threads.
    # It has a pathological behaviour in GHC:
    #   everything program does is thread context switch
    #   100 times per second. It's easily seen with
    #
    #       $ strace -f -p `pidof xmobar`
    #
    #   where rt_sigreturn() manages to enter/exit
    # kernel 32 times in each second to do nothing
    # This workaround allows shrinkng wakeups/thread
    # switches down to one per second (internal xmobar's
    # cycle).
    # Be careful when remove it :]
    HCFLAGS+=" -with-rtsopts=-V0"

    estack_init || die
	epatch "${FILESDIR}/${P}-stack-extra-deps.patch"
    estack setup || die
}

src_compile() {
    estack_install \
        --ghc-options "-with-rtsopts=-V0" \
        --flag xmobar:-all_extensions \
        "$(stack_flag xmobar alsa with_alsa)" \
        "$(stack_flag xmobar with_conduit with_conduit)" \
        "$(stack_flag xmobar timezone with_datezone)" \
        "$(stack_flag xmobar dbus with_dbus)" \
        "$(stack_flag xmobar inotify with_inotify)" \
        "$(stack_flag xmobar wifi with_iwlib)" \
        "$(stack_flag xmobar mpd with_mpd)" \
        "$(stack_flag xmobar mpris with_mpris)" \
        --flag xmobar:with_threaded \
        --flag xmobar:with_utf8 \
        "$(stack_flag xmobar with_uvmeter with_uvmeter)" \
        "$(stack_flag xmobar xft with_xft)" \
        "$(stack_flag xmobar xpm with_xpm)" || die
}

src_install() {
    dobin "${T}/bin/xmobar"

    dodoc samples/xmobar.config readme.md news.md
}
