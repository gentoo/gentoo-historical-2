# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/nettrom/nettrom-2.3.3.ebuild,v 1.7 2004/04/25 09:09:38 vapier Exp $

DESCRIPTION="NetWinder ARM bootloader and utilities"
HOMEPAGE="http://www.netwinder.org/"
SRC_URI="http://gentoo.superlucidity.net/arm/netwinder/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* arm"
IUSE=""

S=${WORKDIR}

src_install() {
	cp -r ${S}/* ${D}/ || die "install failed"
	cd ${D}/usr
	mkdir share
	mv man share
}
