# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/hk_classes/hk_classes-0.6.ebuild,v 1.3 2003/07/20 14:53:15 caleb Exp $

DESCRIPTION="GUI-independent C++ libraries for database applications, plus API documentation and tutorials"
HOMEPAGE="http://hk-classes.sourceforge.net/"
SRC_URI="mirror://sourceforge/sourceforge/hk-classes/${P}.tar.gz
	mirror://sourceforge/sourceforge/knoda/hk_docs-${PV}.tar.gz"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="mysql postgres odbc"

# At least one of the following is required
DEPEND="mysql? ( >=dev-db/mysql-3.23.54a )
	postgres? ( >=dev-db/postgresql-7.3 ) 
        odbc? ( >=dev-db/unixODBC-2.0.6 )"
	
S=${WORKDIR}/${P}

src_compile() {
	local myconf
	myconf="--host=${CHOST} --prefix=/usr/lib/hk_classes \
  		--with-hk_classes-incdir=/usr/include/hk_classes \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man"

	use mysql && myconf="${myconf} --with-mysql-incdir=/usr/include/mysql \
  		--with-mysql-libdir=/usr/lib/mysql"
	use postgres && myconf="${myconf} --with-postgres-incdir=/usr/include/postgresql \
  		--with-postgres-libdir=/usr/lib/postgresql"
	use odbc && myconf="${myconf} --with-odbc-incdir=/usr/include \
  		--with-odbc-libdir=/usr/lib"
	
	./configure ${myconf} || die "./configure failed"
	emake || die
}

src_install() {
	use doc && dohtml -r ${WORKDIR}/hk_docs-${PV}
	make DESTDIR=${D} install || die
}
