# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/gigabase/gigabase-2.75.ebuild,v 1.3 2003/07/11 21:04:10 aliz Exp $

DESCRIPTION="OO-DBMS with interfaces for C/C++/Java/PHP/Perl"
HOMEPAGE="http://www.garret.ru/~knizhnik/gigabase.html"
SRC_URI="http://www.garret.ru/~knizhnik/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND=""
RDEPEND=""

S=${WORKDIR}/gigabase

src_compile() {
	mf="${S}/Makefile"
	
	econf

	sed -r -e 's/subsql([^\.]|$)/subsql-gdb\1/' ${mf} > ${mf}.tmp
	mv ${mf}.tmp ${mf}
	
	emake || die
}

src_install() {
	make \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		install || die
	
	dodoc CHANGES
	dohtml GigaBASE.htm
	dohtml -r docs/html/*
}

pkg_postinst() {
	einfo "The subsql binary has been renamed to subsql-gdb,"
	einfo "to avoid a name clash with the FastDB version of subsql"
}
