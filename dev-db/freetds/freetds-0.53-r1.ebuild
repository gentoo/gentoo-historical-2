# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/freetds/freetds-0.53-r1.ebuild,v 1.4 2003/02/13 10:02:11 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Tabular Datastream Library"
SRC_URI="http://ibiblio.org/pub/Linux/ALPHA/freetds/${P}.tgz"
HOMEPAGE="http://www.freetds.org/"

DEPEND="virtual/glibc"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

src_unpack() {

	unpack ${P}.tgz
	cd ${S}

}

src_compile() {

	econf \
		--with-tdsver=7.0 \
		|| die "./configure failed"

	emake || die

	 mv ${S}/Makefile ${S}/Makefile.orig
	 sed -e 's/^DEFDIR = /DEFDIR = $(DESTDIR)/' \
		 -e 's/^ETC = /ETC = $(DESTDIR)/' \
		 ${S}/Makefile.orig > ${S}/Makefile
}

src_install () {
	make DESTDIR=${D} install || die
}
