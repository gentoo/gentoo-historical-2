# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/sysstat/sysstat-4.0.7.ebuild,v 1.4 2003/06/29 15:24:07 aliz Exp $

DESCRIPTION="System performance tools for Linux"
SRC_URI="http://perso.wanadoo.fr/sebastien.godard/${P}.tar.gz"
HOMEPAGE="http://perso.wanadoo.fr/sebastien.godard/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc "
IUSE="nls"

DEPEND="virtual/glibc"
RDEPEND="nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd ${S}
	cp Makefile Makefile.orig
	sed -e "s:-O2:${CFLAGS}:" Makefile.orig > Makefile
}

src_compile() {
	yes "" | make config
	cp build/CONFIG build/CONFIG.orig
	use nls || sed 's/\(ENABLE_NLS\ =\ \)y/\1n/g' build/CONFIG.orig > build/CONFIG
	make PREFIX=/usr || die
}

src_install() {
	dodir /usr/bin
	dodir /usr/share/man/man{1,8}
	dodir /var/log/sa

	make \
		DESTDIR=${D} \
		PREFIX=/usr \
		MAN_DIR=/usr/share/man \
		DOC_DIR=/usr/share/doc/${PF} \
		install || die
}
