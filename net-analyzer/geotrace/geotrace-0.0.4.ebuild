# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Aron Griffis <agriffis@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/geotrace/geotrace-0.0.4.ebuild,v 1.1 2002/02/17 21:27:40 agriffis Exp $

S=${WORKDIR}/${P}
DESCRIPTION="geographical traceroute utility"
SRC_URI="http://geotrace.sourceforge.net/releases/${P}.tar.gz"
HOMEPAGE="http://geotrace.sourceforge.net/"

DEPEND=">=gtk+-1.2.10-r4
	>=gdk-pixbuf-0.16.0-r1"

src_unpack() {
	unpack ${A}
	cd ${S}
	patch -p1 < ${FILESDIR}/geotrace-map-location.patch
}

src_compile() {
	emake || die
}

src_install () {
	install -d ${D}/usr/bin
	install -d ${D}/usr/share/geotrace
	install -d ${D}/usr/share/geotrace/maps
	install -m755 geotrace ${D}/usr/bin
	install -m644 maps/* ${D}/usr/share/geotrace/maps
	dodoc Changelog COPYRIGHT README
}
