# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/sys-apps/modutils/modutils-2.4.16.ebuild,v 1.3 2002/07/14 19:20:18 aliz Exp $

S=${WORKDIR}/${P}
SLOT="0"
DESCRIPTION="Standard kernel module utilities"
SRC_URI="http://www.kernel.org/pub/linux/utils/kernel/modutils/v2.4/${P}.tar.bz2"
HOMEPAGE=""
KEYWORDS="x86"
LICENSE="GPL-2"
DEPEND="virtual/glibc
	zlib? ( sys-libs/zlib )"

src_compile() {
	myconf=""
	use zlib && myconf="${myconf} --enable-zlib" \
	         || myconf="${myconf} --disable-zlib"

	./configure --prefix=/ \
		--mandir=/usr/share/man \
		--host=${CHOST} \
		--disable-strip \
		${myconf} || die
		
	emake || die
}

src_install() {
	make prefix=${D} \
		mandir=${D}/usr/share/man \
		install || die
		
	dodoc COPYING CREDITS ChangeLog NEWS README TODO
}

