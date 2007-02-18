# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/atop/atop-1.17.ebuild,v 1.3 2007/02/18 15:29:15 blubb Exp $

DESCRIPTION="Resource-specific view of processes"
HOMEPAGE="http://www.atcomputing.nl/Tools/atop"
SRC_URI="http://www.atconsultancy.nl/atop/packages/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="sys-process/acct"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e '/^CFLAGS/s: = -O : += :' \
		-e '/^LDFLAGS/s: = : += :' \
		Makefile
	mv "${S}"/atop.init "${S}"/atop.init.old
	cp "${FILESDIR}"/atop.rc "${S}"/atop.init
	chmod a+rx atop.init
}

src_install() {
	emake DESTDIR="${D}" INIPATH=/etc/init.d install || die
	dodoc README
}
