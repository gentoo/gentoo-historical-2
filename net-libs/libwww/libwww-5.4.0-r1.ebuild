# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-libs/libwww/libwww-5.4.0-r1.ebuild,v 1.1 2002/09/05 07:06:50 satai Exp $

inherit libtool

MY_P=w3c-${P}
S=${WORKDIR}/${MY_P}
DESCRIPTION="A general-purpose client side WEB API"
SRC_URI="http://www.w3.org/Library/Distribution/${MY_P}.tgz"
HOMEPAGE="http://www.w3.org/Library/"

SLOT="0"
LICENSE="W3C"
KEYWORDS="x86 ppc sparc sparc64"


DEPEND="sys-devel/perl
	>=sys-libs/zlib-1.1.4
	mysql? ( >=dev-db/mysql-3.23.26 )
	ssl? ( >=dev-libs/openssl-0.9.6 )"

src_compile() {

	local myconf

	use mysql \
		&& myconf="--with-mysql" \
		|| myconf="--without-mysql"
	
	use ssl \
		&& myconf="${myconf} --with-ssl" \
		|| myconf="${myconf} --without-ssl"

	elibtoolize

	./configure \
		--prefix=/usr \
		--with-zlib \
		--with-md5 \
		--with-expat \
		${myconf} || die

	emake || die

}

src_install () {

	make prefix=${D}/usr install || die
	dodoc COPYRIGH ChangeLog 
	dohtml -r .

}
