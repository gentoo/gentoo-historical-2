# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/hatools/hatools-2.00.ebuild,v 1.1 2007/12/17 18:24:27 armin76 Exp $

DESCRIPTION="hatools: High availability environment tools for shell scripting
(halockrun and hatimerun)"
HOMEPAGE="http://www.fatalmind.com/software/hatools/"
SRC_URI="http://www.fatalmind.com/software/hatools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~mips ~ppc ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README AUTHORS NEWS ChangeLog
}
