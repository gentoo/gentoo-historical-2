# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-server/monopd/monopd-0.8.3.ebuild,v 1.1 2003/11/15 07:21:19 mr_bones_ Exp $

inherit games

DESCRIPTION="server for atlantik games"
HOMEPAGE="http://unixcode.org/monopd/"
SRC_URI="mirror://sourceforge/monopd/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="0"

DEPEND=">=net-libs/libcapsinetwork-0.2.3
	>=sys-libs/libmath++-0.0.3"

src_install() {
	make install DESTDIR=${D} || die "make install failed"
	dodoc doc/api/gameboard API AUTHORS ChangeLog NEWS README* TODO || \
		die "dodoc failed"

	exeinto /etc/init.d
	doexe "${FILESDIR}/monopd" || die "doexe failed"

	prepgamesdirs
}
