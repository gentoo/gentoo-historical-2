# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-server/mtavc/mtavc-0.3.ebuild,v 1.4 2004/06/24 23:21:08 agriffis Exp $

inherit games

DESCRIPTION="A server for a multi-player mod for GTA3: Vice City"
HOMEPAGE="http://mtavc.com/"
SRC_URI="MTAServer-Linux-${PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* x86"
IUSE=""
RESTRICT="fetch"

DEPEND="virtual/glibc
	>=sys-libs/lib-compat-1.2-r1"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please download ${A} from"
	einfo "${HOMEPAGE}downloads.php?file_id=57"
	einfo "and put it in ${DISTDIR}"
}

src_unpack() {
	unpack ${A}
	sed -i 's:NoName:Gentoo:' mtaserver.conf
}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}

	dogamesbin ${FILESDIR}/mtavc
	dosed "s:GENTOO_DIR:${dir}:" ${GAMES_BINDIR}/mtavc

	exeinto ${dir}
	newexe MTAServer${PV} MTAServer
	insinto ${GAMES_SYSCONFDIR}/${PN}
	local files="banned.lst mtaserver.conf motd.txt"
	doins ${files}
	for f in ${files} ; do
		dosym ${GAMES_SYSCONFDIR}/${PN}/${f} ${dir}/${f}
	done

	dodoc CHANGELOG README
	prepgamesdirs
}
