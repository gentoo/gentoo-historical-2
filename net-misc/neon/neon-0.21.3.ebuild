# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/neon/neon-0.21.3.ebuild,v 1.2 2002/07/18 22:09:45 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="HTTP and WebDAV client library"
SRC_URI="http://www.webdav.org/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.webdav.org/neon"
DEPEND="dev-libs/libxml2
		ssl? ( >=dev-libs/openssl-0.9.6 )"

RDEPEND="${DEPEND}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

src_compile() {
	local myconf

	myconf='--enable-shared'

	use ssl && myconf="$myconf --with-ssl"
	
	econf $myconf || die 
	emake || die
}

src_install () {

	make DESTDIR=${D} install || die

	dodoc AUTHORS BUGS ChangeLog NEWS README THANKS TODO doc/*
}

