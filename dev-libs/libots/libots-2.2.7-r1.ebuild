# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libots/libots-2.2.7-r1.ebuild,v 1.3 2004/07/02 04:47:55 eradicator Exp $

At="libots-2.2.7-2.alpha.rpm"
S=${WORKDIR}/usr/lib/compaq/libots-2.2.7
SRC_URI="ftp://ftp.compaq.com/pub/products/linuxdevtools/latest/${At}"
DESCRIPTION="Compaq Linux optimized runtime for Alpha/Linux/GNU"
HOMEPAGE="http://www.support.compaq.com/alpha-tools/"
DEPEND="virtual/libc
	app-arch/rpm2targz "
RDEPEND="$DEPEND"
LICENSE="compaq-sdla"
SLOT="2.2.7"
KEYWORDS="-* ~alpha"

src_unpack() {
	rpm2targz ${DISTDIR}/${At} || die
	tar zxf libots-2.2.7-2.alpha.tar.gz || die
}

src_install () {
	dodir /lib || die
	cp libots.* ${D}/lib || die
	dodoc README || die
}
