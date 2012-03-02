# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/nyancat/nyancat-0.20120302.ebuild,v 1.1 2012/03/02 04:20:34 ssuominen Exp $

EAPI=2
inherit games

DESCRIPTION="Nyan Cat Telnet Server"
HOMEPAGE="http://miku.acm.uiuc.edu/ http://github.com/klange/nyancat"
SRC_URI="http://dev.gentoo.org/~ssuominen/${P}.tar.bz2"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_compile() {
	emake LFLAGS="${LDFLAGS} ${CFLAGS}"
}

src_install() {
	dogamesbin src/${PN}
	dodoc README.md
	prepgamesdirs
}
