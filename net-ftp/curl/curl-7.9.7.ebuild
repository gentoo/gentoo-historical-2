# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/curl/curl-7.9.7.ebuild,v 1.11 2002/12/23 17:37:42 mholzer Exp $

DESCRIPTION="A Client that groks URLs"
SRC_URI="http://curl.haxx.se/download/${P}.tar.bz2"
HOMEPAGE="http://curl.haxx.se"

SLOT="0"
LICENSE="MPL X11"
KEYWORDS="x86 ppc sparc "
IUSE="ssl"

DEPEND=">=sys-libs/pam-0.75 
	ssl? ( >=dev-libs/openssl-0.9.6a )"

src_compile() {
	local myconf
	use ssl \
		&& myconf="--with-ssl" \
		|| myconf="--without-ssl"
	use ipv6 \
		&& myconf="--enable-ipv6" \
		|| myconf="--disable-ipv6"

	econf ${myconf}
	emake || die
}

src_install() {
	make install DESTDIR=${D} || die
	dodoc LEGAL CHANGES README 
	dodoc docs/FEATURES docs/INSTALL docs/INTERNALS docs/LIBCURL 
	dodoc docs/MANUAL docs/FAQ docs/BUGS docs/CONTRIBUTE
}
