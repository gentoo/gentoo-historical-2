# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/atftp/atftp-0.6-r1.ebuild,v 1.3 2003/07/13 11:55:51 aliz Exp $

DESCRIPTION="Advanced TFTP implementation client/server"
HOMEPAGE="ftp://ftp.mamalinux.com/pub/atftp/"
LICENSE="GPL-2"
DEPEND="tcpd? ( sys-apps/tcp-wrappers )"
SLOT="0"
KEYWORDS="x86"
SRC_URI="ftp://ftp.mamalinux.com/pub/atftp/${P}.tar.gz"
S=${WORKDIR}/${P}

src_compile () {
	myconf=""
	use tcpd && myconf="${myconf} --enable-libwrap" \
		|| myconf="${myconf} --disable-libwrap"

	econf ${myconf} || die "./configure failed"

	cp Makefile Makefile.orig
	sed "s:CFLAGS = -g -Wall -D_REENTRANT -O2:CFLAGS = -g -Wall -D_REENTRANT ${CFLAGS}:" Makefile.orig >Makefile

	emake || die
}

src_install () {
	einstall || die "Installation failed"
}

