# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/synaptics/synaptics-0.13.5.ebuild,v 1.6 2005/02/09 03:13:01 battousai Exp $

inherit toolchain-funcs eutils

# This ebuild overwrites synaptics files installed by <= xfree-4.3.0-r6
# and xfree-4.3.99.14 >= X >= xfree-4.3.99.8.

DESCRIPTION="Driver for Synaptics touchpads"
HOMEPAGE="http://w1.894.telia.com/~u89404340/touchpad/"
SRC_URI="http://w1.894.telia.com/~u89404340/touchpad/files/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE=""
RDEPEND="virtual/x11"
DEPEND=">=sys-apps/sed-4"

src_unpack() {
	unpack ${A}

	cd ${S}

	# Put stuff into /usr/X11R6, also switch up the CC and CFLAGS stuff.
	sed -i -e "s:BINDIR = \\\$(DESTDIR)/usr/local/bin:BINDIR = ${D}/usr/X11R6/bin:g" ${S}/Makefile
	sed -i -e "s:CC = gcc:CC = $(tc-getCC):g" ${S}/Makefile
	sed -i -e "s:CDEBUGFLAGS = -O2:CDEBUGFLAGS = ${CFLAGS}:g" ${S}/Makefile
	sed -i -e "s:MANDIR = .*:MANDIR = \\\$(DESTDIR)/usr/man/man1:" ${S}/Makefile
}

src_compile() {
	emake || die
}

src_install() {
	dodir /usr/X11R6/{bin,lib/modules/input}

	# Yes, they got the DESTDIR stuff going. And there was much rejoicing.
	make DESTDIR=${D} install || die
	dodoc {script/usbmouse,alps.patch,COMPATIBILITY,FILES,INSTALL{,.DE},LICENSE,NEWS,TODO,README{,.alps}}
	# Stupid new daemon, didn't work for me because of shm issues
	exeinto /etc/init.d && newexe ${FILESDIR}/rc.init syndaemon
	insinto /etc/conf.d && newins ${FILESDIR}/rc.conf syndaemon
}
