# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/libpqpp/libpqpp-4.0-r2.ebuild,v 1.7 2005/01/01 17:29:05 eradicator Exp $

inherit eutils

MY_P=${P/pp/++}
DESCRIPTION="C++ wrapper for the libpq Postgresql library"
HOMEPAGE="http://gborg.postgresql.org/"
SRC_URI="ftp://gborg.postgresql.org/pub/libpqpp/stable/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/libc
	>=dev-db/postgresql-7.3
	>=sys-apps/sed-4"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.patch
}

src_compile() {
	cp Makefile Makefile.backup
	sed -i "s|\$(POSTGRES_HOME)/lib|/usr/lib/postgresql|g" Makefile || die
	sed -i "s|\$(POSTGRES_HOME)/include|/usr/include/postgresql|g" Makefile || die
	emake || die
	cp Makefile.backup Makefile
}

src_install() {
	sed -i "s|\$(POSTGRES_HOME)/lib|${D}/usr/lib/postgresql|g" Makefile || die
	sed -i "s|\$(POSTGRES_HOME)/include|${D}/usr/include/postgresql|g" Makefile || die
	dodir /usr/lib/postgresql /usr/include/postgresql
	einstall || die "Install failed"
}
