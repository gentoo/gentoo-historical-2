# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Bruce A. Locke <blocke@shivan.org>
# $Header: /var/cvsroot/gentoo-x86/net-libs/libesmtp/libesmtp-0.8.9.ebuild,v 1.1 2002/04/22 00:34:43 rphillips Exp $

A=${P}.tar.bz2
S=${WORKDIR}/${P}
DESCRIPTION="libESMTP is a library that implements the client side of the SMTP protocol"
SRC_URI="http://www.stafford.uklinux.net/libesmtp/${A}"
HOMEPAGE="http://www.stafford.uklinux.net/libesmtp/index.html"

DEPEND="virtual/glibc
	>=sys-devel/libtool-1.3.5-r2
	ssl? ( >=dev-libs/openssl-0.9.6b )"

src_compile() {
	local myconf
	use ssl || myconf="$myconf --without-openssl"

	./configure --prefix=/usr --enable-require-all-recipients $myconf
	assert "configure failed"
	emake || die "emake failed"
}

src_install () {
	make prefix=${D}/usr install || die "make install failed"
	dodoc AUTHORS COPYING COPYING.GPL INSTALL ChangeLog NEWS Notes README TODO doc/api.xml
}
