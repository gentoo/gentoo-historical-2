# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/hatari/hatari-0.45.ebuild,v 1.9 2008/02/26 06:30:47 mr_bones_ Exp $

inherit games

DESCRIPTION="Atari ST emulator"
HOMEPAGE="http://hatari.sourceforge.net/"
SRC_URI="mirror://sourceforge/hatari/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE=""

RDEPEND="games-emulation/emutos
	media-libs/libsdl
	sys-libs/zlib"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e "/^CFLAGS/ s:-O3.*:${CFLAGS}:" \
		-e "/^DATADIR/ s:=.*:= ${GAMES_DATADIR}/${PN}:" Makefile.cnf \
		|| die "sed Makefile.cnf failed"
}

src_compile() {
	cd src
	emake || die "emake failed"
}

src_install() {
	dogamesbin "${S}/src/hatari" || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}/${PN}"
	doins src/font8.bmp || die "doins font8.bmp failed"
	dodoc readme.txt doc/*.txt
	dohtml -r doc/
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	echo
	elog "You need a TOS ROM to run hatari. EmuTOS, a free TOS implementation,"
	elog "has been installed in /usr/games/lib/ with a .img extension (there"
	elog "are several from which to choose)."
	elog
	elog "Another option is to go to http://www.atari.st/ and get a real TOS:"
	elog "  http://www.atari.st/"
	elog
	elog "The first time you run hatari, you should configure it to find the"
	elog "TOS you prefer to use.  Be sure to save your settings."
	echo
}
