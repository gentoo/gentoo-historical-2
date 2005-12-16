# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/audtty/audtty-0.1.2.ebuild,v 1.1 2005/12/16 00:11:46 chainsaw Exp $

IUSE=""

DESCRIPTION="Control Audacious from the command line with a friendly ncurses interface"
HOMEPAGE="http://aerdan.gentoo.bz/page/audtty.html"
SRC_URI="http://aerdan.gentoo.bz/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64"

DEPEND="sys-libs/ncurses
	media-sound/audacious"

src_install() {
	make DESTDIR="${D}" install || die
	dodoc ChangeLog README
}
