# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libpqxx/libpqxx-2.3.0.ebuild,v 1.1 2004/08/22 01:37:31 nakano Exp $

IUSE=""
DESCRIPTION="C++ client API for PostgreSQL. The standard front-end for writing C++ programs that use PostgreSQL. Supersedes older libpq++ interface."
SRC_URI="ftp://gborg.postgresql.org/pub/libpqxx/stable/${P}.tar.gz"
HOMEPAGE="http://pqxx.tk/"

LICENSE="BSD"
KEYWORDS="~x86 ~ppc ~amd64"
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
