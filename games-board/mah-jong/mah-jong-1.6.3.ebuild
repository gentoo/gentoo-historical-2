# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/mah-jong/mah-jong-1.6.3.ebuild,v 1.6 2006/01/29 21:28:01 joshuabaergen Exp $

inherit games

MY_P="mj-${PV}-src"
DESCRIPTION="A networked Mah Jong program, together with a computer player"
HOMEPAGE="http://www.stevens-bradfield.com/MahJong/"
SRC_URI="http://www.stevens-bradfield.com/MahJong/Source/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="=x11-libs/gtk+-1.2*"
DEPEND="${RDEPEND}
	dev-lang/perl"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e '/^.TH/ s/1/6/' xmj.man \
		|| die "sed xmj.man failed"
	sed -i \
		-e "/^DESTDIR =/ s:=.*:= ${D}:" \
		-e "/^BINDIR =/ s:=.*:= ${GAMES_BINDIR}:" \
		-e "/^MANDIR =/ s:man/man1:/usr/share/man/man6:" \
		-e "/^MANSUFFIX =/ s:1:6:" \
		-e "/^CFLAGS =/ s:=:= ${CFLAGS}:" \
		-e "/^TILESETPATH=/ s:NULL:\"${GAMES_DATADIR}/${PN}/\":" Makefile \
		|| die "sed Makefile failed"
}

src_install() {
	make install install.man || die "make install failed"
	dodir "${GAMES_DATADIR}/${PN}"
	cp -R fallbacktiles/ \
		tiles-numbered/ \
		tiles-small/ "${D}${GAMES_DATADIR}/${PN}" \
		|| die "cp failed"
	dodoc CHANGES ChangeLog *.txt
	prepgamesdirs
}
