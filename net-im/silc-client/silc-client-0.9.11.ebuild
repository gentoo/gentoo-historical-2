# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/silc-client/silc-client-0.9.11.ebuild,v 1.4 2003/03/04 07:21:18 vapier Exp $

DESCRIPTION="IRSSI-based text client for Secure Internet Live Conferencing"
SRC_URI="http://www.silcnet.org/download/client/sources/${P}.tar.bz2"
HOMEPAGE="http://silcnet.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc"
IUSE="ipv6 perl"

DEPEND="=dev-libs/glib-1.2*
	perl? ( sys-devel/perl )
	sys-libs/ncurses"

src_compile() {
	econf \
		--mandir=${D}/usr/share/man \
		--with-helpdir=/usr/share/silc/help \
		--with-docdir=/usr/share/doc/${P} \
		--with-simdir=/usr/lib/silc/modules \
		--with-logsdir=/var/log/silc \
		--with-ncurses \
		`use_with ipv6` \
		|| die "./configure failed"

	make || die "make failed"
}

src_install() {
	myflags=""
	if [ "`use perl`" ]
	then
		R1="s/installsitearch='//"
		R2="s/';//"
		perl_sitearch="`perl -V:installsitearch | sed -e ${R1} -e ${R2}`"
		myflags="${myflags} INSTALLPRIVLIB=${D}/usr"
		myflags="${myflags} INSTALLARCHLIB=${D}/${perl_sitearch}"
		myflags="${myflags} INSTALLSITELIB=${D}/${perl_sitearch}"
		myflags="${myflags} INSTALLSITEARCH=${D}/${perl_sitearch}"
	fi

	make DESTDIR=${D} ${myflags} install || die "make install failed"
	rmdir ${D}/usr/include
}
