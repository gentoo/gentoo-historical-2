# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/rekall/rekall-2.2.4.ebuild,v 1.4 2005/09/24 12:17:31 hansmi Exp $

inherit kde

DESCRIPTION="Rekall - a database frontend for MySQL, PostgreSQL and XBase"
HOMEPAGE="http://www.rekallrevealed.org/"
SRC_URI="http://www.rekallrevealed.org/packages/${P}-2.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ppc x86"
IUSE="mysql postgres xbase"

DEPEND="sys-apps/sed
	virtual/python
	mysql? ( >=dev-db/mysql-3.23.57-r1 )
	postgres? ( >=dev-db/postgresql-7.3.4-r1 )
	xbase? ( =dev-db/xbsql-0.11 )"
RDEPEND="virtual/python
	mysql? ( >=dev-db/mysql-3.23.57-r1 )
	postgres? ( >=dev-db/postgresql-7.3.4-r1 )
	xbase? ( =dev-db/xbsql-0.11 )"
need-kde 3

src_unpack() {
	kde_src_unpack
	sed -i -e 's/$(LN_S) $(kde_libs_htmldir)\/$(KDE_LANG)\/common/$(LN_S) common/' ${S}/doc/rekall/Makefile.in
}

src_compile() {
	myconf="--with-gui=kde \
		`use_enable mysql` \
		`use_enable postgres pgsql` \
		`use_enable xbase`"

	kde_src_compile
}

src_install() {
	kde_src_install
	if use postgres; then
		cd "${D}/usr/$(get_libdir)"
		mv libkbase_driver_pgsql.so libkbase_driver_pgsql.so.0.0.0
		ln -s libkbase_driver_pgsql.so.0.0.0 libkbase_driver_pgsql.so.0
		ln -s libkbase_driver_pgsql.so.0.0.0 libkbase_driver_pgsql.so
	fi
	mv ${D}/usr/share/rekall.desktop ${D}/usr/share/applications/rekall.desktop
}
