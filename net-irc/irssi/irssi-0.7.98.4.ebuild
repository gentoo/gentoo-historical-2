# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Tom von Schwerdtner <tvon@etria.org>
# $Header: /var/cvsroot/gentoo-x86/net-irc/irssi/irssi-0.7.98.4.ebuild,v 1.2 2002/02/07 05:15:26 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A modular textUI IRC client with IPv6 support."
SRC_URI="http://irssi.org/files/${P}.tar.bz2"
HOMEPAGE="http://irssi.org"

DEPEND="virtual/glibc
	>=dev-libs/glib-1.2.0
	sys-libs/ncurses
	perl? ( sys-devel/perl ) 
	nls? ( sys-devel/gettext )"


src_compile() {

	# Note: there is an option to build a GUI for irssi, but according
	# to the website the gui is no longer developed, so that option is
	# not used here.
	
	# Edit these if you like
	myconf="--without-servertest --with-bot --with-proxy --with-ncurses"
	
	if [ -z "`use nls`" ]
	then
		myconf="${myconf} --disable-nls"
	fi
	if [ "`use perl`" ]
	then
		myconf="${myconf} --enable-perl=yes"
	fi
	if [ "`use ipv6`" ]
	then
		myconf="${myconf} --enable-ipv6"
	fi

	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--sysconfdir=/etc \
		${myconf} || die "./configure failed"

	emake || die
}

src_install () {

	make DESTDIR=${D} \
		docdir=/usr/share/doc/${PF} \
		gnulocaledir=${D}/usr/share/locale \
		install || die

	dodoc AUTHORS ChangeLog README TODO NEWS
}
