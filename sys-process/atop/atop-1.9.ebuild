# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/atop/atop-1.9.ebuild,v 1.1.1.1 2005/11/30 09:49:10 chriswhite Exp $


DESCRIPTION="Resource-specific view of processes"
SRC_URI="ftp://ftp.atcomputing.nl/pub/tools/linux/${P}.tar.gz
		mirror://gentoo/${P}-initscript"
HOMEPAGE="http://freshmeat.net/releases/112061/"
LICENSE="GPL-2"
SLOT="0"
DEPEND="sys-process/acct"
KEYWORDS="~x86 amd64"
IUSE=""

src_unpack() {
	unpack ${A}
	cd ${S}
	mv ${S}/atop.init ${S}/atop.init.old
	cp ${DISTDIR}/${P}-initscript ${S}/atop.init
}

src_compile() {
	emake || die
}

src_install () {
	make DESTDIR=${D} INIPATH=/etc/init.d install || die

	# Install documentation.
	dodoc README
}
