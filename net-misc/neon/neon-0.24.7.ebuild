# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/neon/neon-0.24.7.ebuild,v 1.12 2005/02/24 01:41:27 vapier Exp $

DESCRIPTION="HTTP and WebDAV client library"
HOMEPAGE="http://www.webdav.org/neon/"
SRC_URI="http://www.webdav.org/neon/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~ppc-macos s390 sh sparc x86"
IUSE="ssl zlib expat"

DEPEND="expat? ( dev-libs/expat )
	!expat? ( dev-libs/libxml2 )
	ssl? ( >=dev-libs/openssl-0.9.6f )
	zlib? ( sys-libs/zlib )"

src_compile() {
	local myc=""
	use expat && myc="$myc --with-expat" || myc="$myc --with-xml2"
	econf \
		--enable-shared \
		$(use_with ssl) \
		$(use_with zlib) \
		${myc} \
		|| die "econf failed"
	emake
}

src_install() {
	einstall || die
	dodoc AUTHORS BUGS ChangeLog NEWS README THANKS TODO doc/*
}
