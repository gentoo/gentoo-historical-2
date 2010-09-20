# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/xrick/xrick-021212-r1.ebuild,v 1.14 2010/09/20 15:50:01 mr_bones_ Exp $

EAPI=2
inherit eutils games

DESCRIPTION="Clone of the Rick Dangerous adventure game from the 80's"
HOMEPAGE="http://www.bigorno.net/xrick/"
SRC_URI="http://www.bigorno.net/xrick/${P}.tgz"

LICENSE="GPL-2 as-is"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"
IUSE=""
RESTRICT="mirror" # bug #149097

DEPEND="media-libs/libsdl[video]"

src_unpack() {
	unpack ${A}
	cd "${S}"
	unpack ./xrick.6.gz
}

src_prepare() {
	sed -i \
		-e "/^run from/d" \
		-e "/data.zip/ s:the directory where xrick is:$(games_get_libdir)/${PN}.:" \
		xrick.6 || die

	sed -i \
		-e "s:data.zip:$(games_get_libdir)/${PN}/data.zip:" \
		src/xrick.c || die

	sed -i \
		-e "s/-g -ansi -pedantic -Wall -W -O2/${CFLAGS}/" \
		-e '/LDFLAGS/s/=/+=/' \
		-e '/CC=/d' \
		-e "/CPP=/ { s/gcc/\$(CC)/; s/\"/'/g }" \
		Makefile || die
}

src_install() {
	dogamesbin xrick || die "dogamesbin failed"
	insinto "$(games_get_libdir)"/${PN}
	doins data.zip || die "doins failed"
	newicon src/xrickST.ico ${PN}.ico
	make_desktop_entry ${PN} ${PN} /usr/share/pixmaps/${PN}.ico
	dodoc README KeyCodes
	doman xrick.6
	prepgamesdirs
}
