# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/le/le-1.9.2.ebuild,v 1.10 2005/05/07 07:25:30 wormo Exp $

DESCRIPTION="Terminal text editor"
HOMEPAGE="http://www.gnu.org/directory/text/editors/le-editor.html"
SRC_URI="http://ftp.yars.free.net/pub/software/unix/util/texteditors/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE=""

DEPEND="virtual/libc
	>=sys-libs/ncurses-5.2-r5"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc ChangeLog FEATURES HISTORY INSTALL NEWS README TODO
}
