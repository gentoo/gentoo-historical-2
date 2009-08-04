# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/dosbox-cvs/dosbox-cvs-20030809.ebuild,v 1.20 2009/08/04 19:05:48 mr_bones_ Exp $

EAPI=2
inherit eutils games cvs

DESCRIPTION="DOS emulator"
HOMEPAGE="http://dosbox.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE="alsa debug hardened opengl sdl png"

DEPEND="alsa? ( media-libs/alsa-lib )
	opengl? ( virtual/opengl )
	png? ( media-libs/libpng )
	debug? ( sys-libs/ncurses )
	media-libs/libsdl[joystick]
	sdl? ( media-libs/sdl-net
		media-libs/sdl-sound )"

ECVS_SERVER="dosbox.cvs.sourceforge.net:/cvsroot/dosbox"
ECVS_MODULE="dosbox"
ECVS_TOP_DIR=${DISTDIR}/cvs-src/${PN}

S=${WORKDIR}/${ECVS_MODULE}

src_configure() {
	local myconf=

	if ! use alsa ; then
		myconf="--without-alsa-prefix --without-alsa-inc-prefix --disable-alsatest"
	fi
	# bug #66038
	if use hardened ; then
		myconf="${myconf} --disable-dynamic-x86"
	fi
	if use debug ; then
		myconf="${myconf} --enable-debug"
	fi
	./autogen.sh || die "autogen.sh failed"
	egamesconf \
		--disable-dependency-tracking \
		${myconf} \
		$(use_enable opengl) \
		|| die
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS
	prepgamesdirs
}
