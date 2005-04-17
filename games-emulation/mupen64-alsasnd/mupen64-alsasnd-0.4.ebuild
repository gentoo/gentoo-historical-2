# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/mupen64-alsasnd/mupen64-alsasnd-0.4.ebuild,v 1.8 2005/04/17 21:56:05 morfic Exp $

inherit games eutils

DESCRIPTION="Alsa plugin for the mupen64 N64 emulator"
HOMEPAGE="http://www.emutalk.net/showthread.php?threadid=16895"
SRC_URI="alsa-plugin-${PV}fix.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* x86"
IUSE="qt gtk gtk2"
RESTRICT="fetch"

DEPEND=">=media-libs/alsa-lib-0.9.0
	|| (
		gtk? ( =x11-libs/gtk+-1* )
		gtk2? ( =x11-libs/gtk+-2* )
		qt? ( >=x11-libs/qt-3 )
	)"

S="${WORKDIR}/alsa_plugin"

pkg_nofetch() {
	einfo "Please visit this page to download the tarball:"
	einfo "http://www.emutalk.net/showpost.php?postid=170173&postcount=12"
	einfo "Then just put ${A} in ${DISTDIR} !"
}

pkg_setup() {
	if ! use gtk && ! use gtk2 && ! use qt ; then
		eerror "You must choose either gtk, gtk2 or qt as interface"
		die "User Choice of Interface required"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PV}-gentoo.patch" || die "gentoo patch failed"
	epatch "${FILESDIR}/${PV}-gtk.patch" || die "gtk patch failed"
}

src_compile() {
	use qt && export GRAPHICAL_INTERFACE=qt3
	use gtk && export GRAPHICAL_INTERFACE=gtk1
	use gtk2 && export GRAPHICAL_INTERFACE=gtk2
	emake || die "make failed"
}

src_install() {
	exeinto "${GAMES_LIBDIR}/mupen64/plugins"
	doexe mupen64_alsasnd-${PV}.so || die "doexe failed"
	dodoc README
	prepgamesdirs
}
