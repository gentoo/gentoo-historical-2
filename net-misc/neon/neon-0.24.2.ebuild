# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/neon/neon-0.24.2.ebuild,v 1.3 2003/11/29 03:32:32 weeve Exp $

S=${WORKDIR}/${P}
DESCRIPTION="HTTP and WebDAV client library"
SRC_URI="http://www.webdav.org/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.webdav.org/neon"
DEPEND="dev-libs/libxml2
	ssl? ( >=dev-libs/openssl-0.9.6f )"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc"
IUSE="ssl"

src_compile() {
	local myc='--enable-shared'

	use ssl && myc="$myc --with-ssl"
	use zlib && myc="$myc --with-zlib" || myc="$myc --without-zlib"

	econf $myc
	emake
}

src_install () {
	einstall
	dodoc AUTHORS BUGS ChangeLog NEWS README THANKS TODO doc/*
}
