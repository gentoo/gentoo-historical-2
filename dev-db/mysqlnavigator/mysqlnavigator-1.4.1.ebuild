# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/mysqlnavigator/mysqlnavigator-1.4.1.ebuild,v 1.2 2003/01/03 09:59:38 hannes Exp $

IUSE=""
DESCRIPTION="Advanced Qt based front end to mysql"
SRC_URI="http://sql.kldp.org/snapshots/source/${P}.tar.gz"
HOMEPAGE="http://sql.kldp.org/mysql"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND=">=dev-db/mysql-3.23.49
	>=x11-libs/qt-3.0.3"

src_unpack() {
	unpack ${A}
	cd ${S}/src/mysql
	rm */*_moc.cpp
}

src_compile() {
	myconf="--with-mysql-includes=/usr/include/mysql"
	econf ${myconf}
	emake
}

src_install() {
	einstall
}
