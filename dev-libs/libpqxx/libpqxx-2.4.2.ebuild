# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libpqxx/libpqxx-2.4.2.ebuild,v 1.2 2005/02/09 22:07:00 nakano Exp $

IUSE=""
DESCRIPTION="C++ client API for PostgreSQL. The standard front-end for writing C++ programs that use PostgreSQL. Supersedes older libpq++ interface."
SRC_URI="ftp://gborg.postgresql.org/pub/libpqxx/stable/${P}.tar.gz"
HOMEPAGE="http://pqxx.tk/"

LICENSE="BSD"
KEYWORDS="x86 ~amd64"
SLOT="0"

DEPEND="dev-db/postgresql"

src_compile() {
	econf --enable-shared || die "./configure failed"
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog COPYING INSTALL NEWS README* TODO
	dohtml -r doc/html/*
}
