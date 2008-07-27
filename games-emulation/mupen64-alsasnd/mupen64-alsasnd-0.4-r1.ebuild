# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/mupen64-alsasnd/mupen64-alsasnd-0.4-r1.ebuild,v 1.3 2008/07/27 21:20:19 carlo Exp $

EAPI=1

inherit eutils qt3 games

DESCRIPTION="Alsa plugin for the mupen64 N64 emulator"
HOMEPAGE="http://www.emutalk.net/showthread.php?threadid=16895"
SRC_URI="mirror://gentoo/alsa-plugin-${PV}fix.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* x86"
IUSE="gtk qt3"

DEPEND="media-libs/alsa-lib
	gtk? ( =x11-libs/gtk+-2* )
	qt3? ( x11-libs/qt:3 )
	!gtk? ( !qt3? ( =x11-libs/gtk+-2* ) )"

S=${WORKDIR}/alsa_plugin

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch \
		"${FILESDIR}"/${PV}-gentoo.patch \
		"${FILESDIR}"/${PV}-gtk.patch \
		"${FILESDIR}"/${P}-gcc41.patch
}

src_compile() {
	export GRAPHICAL_INTERFACE=gtk2
	use qt3 && export GRAPHICAL_INTERFACE=qt3
	use gtk && export GRAPHICAL_INTERFACE=gtk2
	emake || die "emake failed"
	unset GRAPHICAL_INTERFACE
}

src_install() {
	exeinto "$(games_get_libdir)"/mupen64/plugins
	doexe mupen64_alsasnd-${PV}.so || die "doexe failed"
	dodoc README
	prepgamesdirs
}
