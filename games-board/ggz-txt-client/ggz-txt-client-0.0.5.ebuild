# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/ggz-txt-client/ggz-txt-client-0.0.5.ebuild,v 1.3 2004/06/03 22:44:02 mr_bones_ Exp $

DESCRIPTION="The textbased client for GGZ Gaming Zone"
HOMEPAGE="http://ggz.sourceforge.net/"
SRC_URI="mirror://sourceforge/ggz/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE=""

DEPEND="~dev-games/ggz-client-libs-0.0.5"

src_install() {
	make DESTDIR=${D} install || die
}
