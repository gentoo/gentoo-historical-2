# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/heroes/heroes-0.21-r1.ebuild,v 1.6 2006/09/20 12:26:36 kugelfang Exp $

inherit eutils games

data_ver=1.5
snd_trk_ver=1.0
snd_eff_ver=1.0

DESCRIPTION="Heroes Enjoy Riding Over Empty Slabs: similar to Tron and Nibbles"
HOMEPAGE="http://heroes.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2
	mirror://sourceforge/${PN}/${PN}-data-${data_ver}.tar.bz2
	mirror://sourceforge/${PN}/${PN}-sound-tracks-${snd_trk_ver}.tar.bz2
	mirror://sourceforge/${PN}/${PN}-sound-effects-${snd_eff_ver}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="sdl nls ggi"

DEPEND="nls? ( sys-devel/gettext )
	sdl? ( media-libs/libsdl media-libs/sdl-mixer )
	ggi? ( media-libs/libggi media-libs/libgii media-libs/libmikmod )
	!sdl? ( !ggi? ( media-libs/libsdl media-libs/sdl-mixer ) )"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	cd ${WORKDIR}/${P}
	epatch ${FILESDIR}/${PV}-cvs-segfault-fix.patch #56118
	epatch "${FILESDIR}/${P}"-gcc4.patch
}

src_compile() {
	local myconf="--disable-heroes-debug $(use_enable nls)"

	if use sdl || ! use ggi ; then
		myconf="${myconf} --with-sdl --with-sdl-mixer"
	else
		myconf="${myconf} --with-ggi --with-mikmod"
	fi

	for pkg in ${A//.tar.bz2} ; do
		cd ${S}/${pkg}
		egamesconf ${myconf}
		make || die "unable to compile ${pkg}"
	done
}

src_install() {
	for pkg in ${A//.tar.bz2} ; do
		cd ${S}/${pkg}
		make DESTDIR=${D} install || die
	done
	prepgamesdirs
}
