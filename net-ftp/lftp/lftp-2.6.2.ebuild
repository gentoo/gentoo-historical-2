# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/lftp/lftp-2.6.2.ebuild,v 1.6 2002/12/09 04:33:12 manson Exp $

IUSE="ssl socks5 nls"

S=${WORKDIR}/${P}

DESCRIPTION="LFTP is a sophisticated ftp/http client, file transfer program."
HOMEPAGE="http://ftp.yars.free.net/projects/lftp/"
SRC_URI="http://ftp.yars.free.net/pub/software/unix/net/ftp/client/lftp/${P}.tar.bz2"

DEPEND=">=sys-libs/ncurses-5.1 
	ssl? ( >=dev-libs/openssl-0.9.6 )
	socks5? ( >=net-misc/dante-1.1.12 )
	nls? ( sys-devel/gettext )"
RDEPEND="nls? ( sys-devel/gettext )"	

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc -sparc  alpha"

src_unpack() {

	unpack ${A}
	cd ${S}
	patch -p1 < ${FILESDIR}/configure-lftp-2.6.2.diff \
		|| die "patch failed"

}

src_compile() {

	local myconf

	use nls && myconf="--enable-nls" \
		|| myconf="--disable-nls"

	use ssl && myconf="${myconf} --with-ssl=/usr" \
		|| myconf="${myconf} --without-ssl"

	use socks5 && myconf="${myconf} --with-socksdante=/usr" \
		|| myconf="${myconf} --without-socksdante"

	export CFLAGS="-fno-exceptions -fno-rtti ${CFLAGS}"
	export CXXFLAGS="-fno-exceptions -fno-rtti ${CXXFLAGS}"

	./configure \
		--prefix=/usr \
		--sysconfdir=/etc/lftp \
		--without-modules \
		--mandir=/usr/share/man \
		--host=${CHOST} ${myconf} || die "bad ./configure"

	make || die "compile problem"
}

src_install() {

	make install DESTDIR=${D} || die

	# hrmph, empty..
	rm -rf ${D}/usr/lib

	dodoc BUGS COPYING ChangeLog FAQ FEATURES MIRRORS \
		NEWS README* THANKS TODO
	
}
