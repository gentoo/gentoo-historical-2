# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/searchtool/searchtool-0.4.4.ebuild,v 1.2 2004/04/18 06:37:08 mr_bones_ Exp $

inherit games

DESCRIPTION="server browser for Internet games"
HOMEPAGE="http://searchtool.sourceforge.net/"
SRC_URI="mirror://sourceforge/searchtool/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="dev-java/ant"
RDEPEND="virtual/jre"

S="${WORKDIR}/${PN}"

src_compile() {
	ant || die "ant failed"
	sed \
		-e "s:GENTOO_DATADIR:${GAMES_DATADIR}/${PN}:" \
		-e "s:GENTOO_P:${P}:" \
		${FILESDIR}/searchtool > searchtool
}

src_install() {
	dogamesbin searchtool || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}/${PN}"
	doins ${P}.jar
	dodoc README
	prepgamesdirs
}
