# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/bmon/bmon-1.2.0.ebuild,v 1.5 2004/07/08 16:39:32 eldad Exp $

DESCRIPTION="bmon is an interface bandwidth monitor."
HOMEPAGE="http://trash.net/~reeler/bmon"
SRC_URI="http://trash.net/~reeler/bmon/files/${P}.tar.bz2"
LICENSE="Artistic"
SLOT="0"
KEYWORDS="x86 ~ppc sparc"
IUSE=""
DEPEND=">=sys-libs/ncurses-5.3-r2" # not sure but

src_install() {
	einstall || die
	cd ${S}
	dodoc AUTHORS COPYING ChangeLog
}
