# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/silc-client/silc-client-1.0.1.ebuild,v 1.7 2004/10/04 22:36:16 pvdabeel Exp $

DESCRIPTION="IRSSI-based text client for Secure Internet Live Conferencing"
SRC_URI="http://www.silcnet.org/download/client/sources/${P}.tar.bz2"
HOMEPAGE="http://silcnet.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc ~sparc amd64"
IUSE="ipv6 perl socks5"

DEPEND="=dev-libs/glib-1.2*
	perl? ( dev-lang/perl )
	socks5? ( net-misc/dante )
	sys-libs/ncurses"

src_compile() {
	local myconf
	use ipv6 && myconf="${myconf} --enable-ipv6"
	use socks5 && myconf="${myconf} --with-socks5"

	econf \
		--prefix=/usr \
		--datadir=/usr/share/${PN} \
		--with-datadir=/usr/share/${PN} \
		--with-docdir=/usr/share/doc/${PN} \
		--with-helpdir=/usr/share/${PN}/help \
		--with-logsdir=/var/log/${PN} \
		--with-simdir=/usr/lib/${PN} \
		--with-mandir=/usr/share/man \
		--with-ncurses \
		--without-silcd \
		${myconf} \
		|| die "./configure failed"

	make || die "make failed"
}

src_install() {
	myflags=""
	if use perl
	then
		R1="s/installsitearch='//"
		R2="s/';//"
		perl_sitearch="`perl -V:installsitearch | sed -e ${R1} -e ${R2}`"
		myflags="${myflags} INSTALLPRIVLIB=/usr/lib"
		myflags="${myflags} INSTALLARCHLIB=${perl_sitearch}"
		myflags="${myflags} INSTALLSITELIB=${perl_sitearch}"
		myflags="${myflags} INSTALLSITEARCH=${perl_sitearch}"
	fi

	make DESTDIR=${D} ${myflags} install || die "make install failed"
	mv ${D}/usr/libsilc.a ${D}/usr/lib/
	mv ${D}/usr/libsilcclient.a ${D}/usr/lib/
	mv ${D}/usr/libsilcclient.la ${D}/usr/lib/
	mv ${D}/usr/libsilc.la ${D}/usr/lib/
	rmdir ${D}/usr/share/silc/
	rmdir ${D}/usr/include

	dodir /usr/share/man
	mv ${D}/man1 ${D}/usr/share/man
}
