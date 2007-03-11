# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/fastjar/fastjar-0.94.ebuild,v 1.3 2007/03/11 20:51:02 nichoj Exp $

DESCRIPTION="A jar program written in C"
HOMEPAGE="http://fastjar.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE=""

RDEPEND=""
DEPEND=""

src_install() {
	emake DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS CHANGES NEWS README || die
}
