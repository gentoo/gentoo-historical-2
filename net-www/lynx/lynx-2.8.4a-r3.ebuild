# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-www/lynx/lynx-2.8.4a-r3.ebuild,v 1.4 2002/07/11 06:30:49 drobbins Exp $

S=${WORKDIR}/lynx2-8-4
HOMEPAGE="http://lynx.browser.org/"
SRC_URI="ftp://lynx.isc.org/lynx2.8.4/lynx2.8.4.tar.bz2"

DESCRIPTION="An excellent console-based web browser with ssl support"

DEPEND="virtual/glibc
        >=sys-libs/ncurses-5.1
        >=sys-libs/zlib-1.1.3
        nls? ( sys-devel/gettext )
        ssl? ( >= dev-libs/openssl-0.9.6 )"

src_unpack() {
	unpack ${A}
	cd ${S}
	patch -p1 < ${FILESDIR}/lynx2.8.4rel.1a.patch || die
}

src_compile() {
	local myconf
	use nls && myconf="${myconf} --enable-nls"
	use ssl && myconf="${myconf} --with-ssl=yes"
	use ipv6 && myconf="${myconf} --enable-ipv6"

	./configure --prefix=/usr --mandir=/usr/share/man --datadir=/usr/share \
	--libdir=/etc/lynx --enable-cgi-links --enable-prettysrc \
	--enable-nsl-fork --enable-file-upload --enable-read-eta \
	--enable-libjs --enable-color-style --enable-scrollbar \
	--enable-included-msgs --with-zlib --host=${CHOST} ${myconf}
	assert

	emake || die "compile problem"
}

src_install() {
	make prefix=${D}/usr datadir=${D}/usr/share mandir=${D}/usr/share/man \
		libdir=${D}/etc/lynx install || die

	dodoc CHANGES COPYHEADER COPYING INSTALLATION PROBLEMS README
	docinto docs
	dodoc docs/*
	docinto lynx_help
	dodoc lynx_help/*.txt
	dohtml -r lynx_help
	
	# small little manpage glitch
	rm ${D}/usr/share/man/lynx.1
	newman lynx.man lynx.1
}
