# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/crack-attack/crack-attack-1.1.9.ebuild,v 1.1 2003/10/06 03:43:48 mr_bones_ Exp $

inherit games flag-o-matic
append-flags -DGL_GLEXT_LEGACY

DESCRIPTION="Addictive OpenGL-based block game"
HOMEPAGE="http://aluminumangel.org/attack/"
SRC_URI="http://aluminumangel.org/cgi-bin/download_counter.cgi?attack_linux+attack/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="0"

RDEPEND="media-libs/glut"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i \
		-e 's:-O6:@CXXFLAGS@:' src/Makefile.in || \
			die "sed src/Makefile.in failed"
}

src_install() {
	make DESTDIR=${D} install      || die "make install failed"
	dodoc AUTHORS ChangeLog README || die "dodoc failed"
	dohtml -A xpm doc/*            || die "dohtml failed"
	prepgamesdirs
}
