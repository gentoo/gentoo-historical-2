# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-ftp/lftp/lftp-2.6.1.ebuild,v 1.1 2002/08/13 21:15:09 raker Exp $

S=${WORKDIR}/${P}
DESCRIPTION="LFTP is a sophisticated ftp/http client, file transfer program."
HOMEPAGE="http://ftp.yars.free.net/projects/lftp/"
SRC_URI="http://ftp.yars.free.net/pub/software/unix/net/ftp/client/lftp/${P}.tar.bz2"

DEPEND=">=sys-libs/ncurses-5.1 
	ssl? ( >=dev-libs/openssl-0.9.6 )"
	
RDEPEND="nls? ( sys-devel/gettext )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc -sparc -sparc64"

src_compile() {

	local myconf
	use nls || myconf="--disable-nls"
	use ssl || myconf="${myconf} --without-ssl"

	export CFLAGS="-fno-exceptions -fno-rtti ${CFLAGS}"
	export CXXFLAGS="-fno-exceptions -fno-rtti ${CXXFLAGS}"

	./configure \
		--prefix=/usr \
		--sysconfdir=/etc/lftp \
		--without-modules \
		--mandir=/usr/share/man \
		--host=${CHOST} ${myconf} || die "bad ./configure"

	emake || die "compile problem"
}

src_install() {

	make install DESTDIR=${D} || die

	# hrmph, empty..
	rm -rf ${D}/usr/lib

	dodoc BUGS COPYING ChangeLog FAQ FEATURES MIRRORS \
		NEWS README* THANKS TODO
	
}
