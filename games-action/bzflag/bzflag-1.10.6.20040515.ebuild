# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/bzflag/bzflag-1.10.6.20040515.ebuild,v 1.1 2004/05/17 04:59:19 vapier Exp $

inherit games

DESCRIPTION="OpenGL accelerated 3d tank combat simulator game"
HOMEPAGE="http://www.BZFlag.org/"
SRC_URI="mirror://sourceforge/bzflag/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc amd64"
IUSE=""

DEPEND="virtual/opengl"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i \
		-e 's:^CFLAGS=.*::' \
		-e 's:^CXXFLAGS=.*::' \
		-e 's:-mcpu=$host_cpu::' \
		configure
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS README.UNIX TODO README ChangeLog BUGS PORTING
	prepgamesdirs
}
