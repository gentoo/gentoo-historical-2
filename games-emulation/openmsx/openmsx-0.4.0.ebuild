# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/openmsx/openmsx-0.4.0.ebuild,v 1.2 2004/06/14 05:29:44 mr_bones_ Exp $

inherit flag-o-matic eutils games

DESCRIPTION="MSX emulator that aims for perfection"
HOMEPAGE="http://openmsx.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~ppc"
IUSE=""

DEPEND="dev-lang/tcl
	dev-libs/libxml2
	media-libs/libpng
	sys-libs/zlib
	media-libs/sdl-image
	media-libs/libsdl
	virtual/x11
	virtual/opengl"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch "${FILESDIR}/${P}-custom.mk.patch"
	epatch "${FILESDIR}/${P}-symlinking.patch"
}

src_compile() {
	# fix bug 32745
	replace-flags -Os -O2
	egamesconf || die
	emake || die "Fatal error during compilation"
}

src_install() {
	egamesinstall \
		OPENMSX_INSTALL="${D}/usr/games/openmsx" || die

	dodoc README AUTHORS
	dohtml -r doc/*

	# Tidy up install
	rm -f "${D}${GAMES_DATADIR}/openmsx/"*.{txt,tex,html,png,css}

	prepgamesdirs
}
