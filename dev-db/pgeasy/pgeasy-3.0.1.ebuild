# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/pgeasy/pgeasy-3.0.1.ebuild,v 1.1 2003/04/04 19:51:27 mkennedy Exp $

DESCRIPTION="An easy-to-use C interface to PostgreSQL."
HOMEPAGE="http://gborg.postgresql.org/project/pgeasy/projdisplay.php"
SRC_URI="ftp://gborg.postgresql.org/pub/pgeasy/stable/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-db/postgresql-7.3.2"

S=${WORKDIR}/${P}

src_unpack() {
	unpack ${A}
	cd ${S} && patch -p0 <${FILESDIR}/Makefile-gentoo.patch || die
}

src_compile() {
	make POSTGRES_HOME=/usr CFLAGS="${CFLAGS}" || die
}

src_install() {
	dodir /usr/lib
	dodir /usr/include
	make POSTGRES_HOME=${D}/usr install || die
	dodoc CHANGES README
	dohtml docs/*.html
	cp -r examples ${D}/usr/share/doc/${P}/
}

# Notes: pgeasy won't build static libraries
