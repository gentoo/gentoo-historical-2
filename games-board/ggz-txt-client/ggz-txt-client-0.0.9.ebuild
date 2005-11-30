# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/ggz-txt-client/ggz-txt-client-0.0.9.ebuild,v 1.1 2004/12/26 23:10:50 vapier Exp $

DESCRIPTION="The textbased client for GGZ Gaming Zone"
HOMEPAGE="http://ggz.sourceforge.net/"
SRC_URI="http://ftp.ggzgamingzone.org/pub/ggz/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND=">=dev-games/ggz-client-libs-${PV}
	sys-libs/ncurses
	sys-libs/readline"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i 's:-lreadline:-lreadline -lncurses:' configure
	sed -i 's:dir=$(prefix):dir=$(DESTDIR)$(prefix):' po/Makefile.in
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog INSTALL NEWS QuickStart.GGZ README* TODO
}
