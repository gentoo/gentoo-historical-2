# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/rats/rats-2.1.ebuild,v 1.10 2006/05/06 12:51:06 blubb Exp $

DESCRIPTION="RATS - Rough Auditing Tool for Security"
HOMEPAGE="http://www.securesoftware.com/download_${PN}.htm"
SRC_URI="http://www.securesoftware.com/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""
DEPEND="dev-libs/expat virtual/libc"

src_compile() {
	econf --datadir="/usr/share/${PN}/" || die
	emake || die
}

src_install () {
	einstall SHAREDIR="${D}/usr/share/${PN}" MANDIR="${D}/usr/share/man" || die
	dodoc README README.win32 COPYING
}
