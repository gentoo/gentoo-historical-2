# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/smartsuite/smartsuite-2.1.ebuild,v 1.7 2002/10/20 18:14:57 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Suite to control and monitor storage devices using SMART technology."
HOMEPAGE="http://www.linux-ide.org/smart.html"
SRC_URI="mirror://sourceforge/smartsuite/${P}.tar.gz
	http://www.linux-ide.org/smart/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc sparc64"

DEPEND="virtual/glibc"

src_unpack() {

	unpack ${A}
	cd ${S}
	sed -e "/^CFLAGS/ s/-O2/$CFLAGS/" < Makefile > Makefile.hacked
	mv Makefile.hacked Makefile

}

src_compile() {

	emake || die

}

src_install() {

	dosbin smartctl smartd
	doman smartctl.8 smartd.8

	insinto /etc/init.d
	newins ${FILESDIR}/smartd.rc smartd

	dodoc CHANGELOG TODO COPYING README

}
