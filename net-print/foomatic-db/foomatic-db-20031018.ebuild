# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/foomatic-db/foomatic-db-20031018.ebuild,v 1.1 2003/10/18 10:54:05 lanius Exp $

DESCRIPTION="Foomatic printer database"
HOMEPAGE="http://www.linuxprinting.org/foomatic"
SRC_URI="http://www.linuxprinting.org/download/foomatic/${P}.tar.gz
	ppds? ( http://www.linuxprinting.org/download/foomatic/foomatic-filters-ppds-${PV}.tar.gz )"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~amd64"
IUSE="cups ppds"

DEPEND="dev-libs/libxml2
	net-misc/wget
	net-ftp/curl
	net-print/foomatic-filters
	net-print/foomatic-db-engine"

src_unpack() {
	unpack ${A}
}

src_compile() {
	econf || die
	rm db/source/driver/stp.xml

	if [ "`use ppds`" ]; then
		cd ../foomatic-filters-ppds-${PV}
		rm -f `find . -name "*gimp-print*" `
		rm -f `find . -name "*hpijs*" `
	fi
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"

	if [ "`use ppds`" ]; then
		cd ../foomatic-filters-ppds-${PV}
		./install -p ${D}/usr -z
		if [ "`use cups`" ]; then
			dodir /usr/share/cups/model
			dosym /usr/share/ppd /usr/share/cups/model/foomatic-ppds
		fi
	fi
}
