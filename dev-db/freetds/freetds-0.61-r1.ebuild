# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/freetds/freetds-0.61-r1.ebuild,v 1.1 2003/09/22 12:18:14 seemant Exp $

DESCRIPTION="Tabular Datastream Library"
SRC_URI="http://ibiblio.org/pub/Linux/ALPHA/freetds/stable/${P}.tgz"
HOMEPAGE="http://www.freetds.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~sparc ~ppc ~mips ~arm hppa ~alpha amd64"

DEPEND="virtual/glibc"
S=${WORKDIR}/${P}

src_compile() {
	econf --with-tdsver=7.0
	emake || die
}

src_install() {
	mv ${S}/Makefile ${S}/Makefile.orig
	sed -e 's/^DEFDIR = /DEFDIR = $(DESTDIR)/' \
		 ${S}/Makefile.orig > ${S}/Makefile
	make DESTDIR=${D} install || die
}
