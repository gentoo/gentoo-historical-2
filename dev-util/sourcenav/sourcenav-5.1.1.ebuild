# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/sourcenav/sourcenav-5.1.1.ebuild,v 1.6 2003/07/12 14:28:13 aliz Exp $

S=${WORKDIR}/build

DESCRIPTION="Source-Navigator is a source code analysis tool"
SRC_URI="mirror://sourceforge/sourcenav/${P}.tar.gz"
HOMEPAGE="http://sourcenav.sourceforge.net"

SLOT="0"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="x86 ~sparc  ~ppc"
DEPEND=">=sys-libs/glibc-2.2.4"
SN="/usr/snavigator"

src_unpack() {
	mkdir build
	unpack ${A}

	cd ${WORKDIR}/${P}

	patch -p0 < ${FILESDIR}/${PF}-gentoo.diff
}

src_compile() {
	../${P}/configure \
		--host=${CHOST} \
		--prefix=${SN} \
		--mandir=${SN}/share/man \
		--infodir=${SN}/share/info \
		--datadir=${SN}/share || die

	make all-snavigator || die
}

src_install() {
	make DESTDIR=${D} \
		install-snavigator || die
	
	chmod -Rf 755 ${D}/usr/share/doc/${P}/demos
	dodir /etc/env.d
	echo "PATH=/usr/snavigator/bin" > ${D}/etc/env.d/10snavigator	
}
