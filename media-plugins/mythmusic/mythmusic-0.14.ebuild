# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/mythmusic/mythmusic-0.14.ebuild,v 1.7 2004/06/24 23:33:42 agriffis Exp $

inherit gcc flag-o-matic eutils

DESCRIPTION="Music player module for MythTV."
HOMEPAGE="http://www.mythtv.org/"
SRC_URI="http://www.mythtv.org/mc/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="opengl sdl X"

DEPEND=">=media-sound/cdparanoia-3.9.8
	>=media-libs/libmad-0.14.2b
	>=media-libs/libid3tag-0.14.2b
	>=media-libs/libvorbis-1.0
	>=media-libs/libcdaudio-0.99.6
	>=media-libs/flac-1.1.0
	>=sys-apps/sed-4
	X? ( =dev-libs/fftw-2* )
	opengl? ( virtual/opengl =dev-libs/fftw-2* )
	sdl? ( >=media-libs/libsdl-1.2.5 )
	|| ( >=media-tv/mythtv-${PV} >=media-tv/mythfrontend-${PV} )"

src_unpack() {
	unpack ${A} && cd "${S}"

	for i in `grep -lr "usr/local" "${S}"` ; do
		sed -e "s:/usr/local:/usr:" -i "${i}" || die "sed failed"
	done

	# This was fixed in CVS but didn't make it into 0.14
	# There is a problem  in the goom plugin
	# 20040429 - raker@gentoo.org
	epatch ${FILESDIR}/asm_fix.diff
}

src_compile() {
	local myconf
	myconf="${myconf} `use_enable X fftw`"
	myconf="${myconf} `use_enable opengl`"
	myconf="${myconf} `use_enable sdl`"

	if [ "`gcc-version`" = "3.2" ] || [ "`gcc-version`" = "3.3" ] ; then
		replace-flags mcpu=pentium4 mcpu=pentium3
		replace-flags march=pentium4 march=pentium3
	fi

	local cpu="`get-flag march || get-flag mcpu`"
	if [ "${cpu}" ] ; then
		sed -e "s:pentiumpro:${cpu}:g" -i "settings.pro" || die "sed failed"
	fi

	qmake -o "Makefile" "${PN}.pro"

	econf ${myconf} || die "econf failed"
	emake || die "compile problem"
}

src_install() {
	einstall INSTALL_ROOT="${D}"
	dodoc AUTHORS COPYING README UPGRADING
}
