# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/gps/gps-1.1.0.ebuild,v 1.7 2004/05/31 19:21:32 vapier Exp $

DESCRIPTION="Graphical (GTK+1.2) Process Statistics"
HOMEPAGE="http://gps.seul.org/"
SRC_URI="ftp://ftp.seul.org/pub/gps/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE=""

DEPEND="=x11-libs/gtk+-1.2*"

src_install() {
	make DESTDIR=${D} install || die

	exeinto /etc/init.d
	doexe ${FILESDIR}/rgpsp

	dodoc TODO README* CHANGELOG INSTALL

	doman rgpsp/rgpsp.1
	doman gps.1x


	insinto /etc
	newins rgpsp/sample.rgpsp.conf rgpsp.conf

	rm -rf ${D}/usr/man ${D}/usr/doc ${D}/etc/rc.d
	rm -f ${D}/usr/bin/rgpsp

	dosym /usr/bin/rgpsp_linux /usr/bin/rgpsp
}
