# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-nds/yp-tools/yp-tools-2.4-r3.ebuild,v 1.1 2002/04/27 21:23:12 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="NIS Tools"
SRC_URI="ftp://ftp.de.kernel.org/pub/linux/utils/net/NIS/${P}.tar.gz
	 ftp://ftp.uk.kernel.org/pub/linux/utils/net/NIS/${P}.tar.gz
	 ftp://ftp.kernel.org/pub/linux/utils/net/NIS/${P}.tar.gz"
HOMEPAGE="http://www.suse.de/~kukuk/nis/yp-tools/index.html"

DEPEND="virtual/glibc"


src_compile() {
	local myconf

	myconf="--sysconfdir=/etc/yp"
	use nls || myconf="${myconf} --disable-nls"

	econf ${myconf} || die
	make || die
}

src_install() {															 
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog COPYING NEWS README THANKS TODO
	insinto /etc/yp
	doins etc/nicknames
	# This messes up boot so we remove it
	rm -d ${D}/bin/ypdomainname
	rm -d ${D}/bin/nisdomainname
	rm -d ${D}/bin/domainname
}
