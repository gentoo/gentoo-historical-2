# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/xvt/xvt-2.1.ebuild,v 1.4 2004/04/27 18:25:13 agriffis Exp $

inherit ccc eutils flag-o-matic

DESCRIPTION="A tiny vt100 terminal emulator for X"
HOMEPAGE="ftp://ftp.x.org/R5contrib/xvt-1.0.README"
SRC_URI="ftp://ftp.x.org/R5contrib/xvt-1.0.tar.Z"
LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 ~alpha"
IUSE=""
DEPEND="virtual/x11"
S=${WORKDIR}/${PN}-1.0

src_unpack() {
	unpack ${A}

	# this brings the distribution upto version 2.1
	cd ${S}; epatch ${FILESDIR}/xvt-2.1.diff.gz

	# set the makefile options
	sed -i 's/#\(ARCH=LINUX\)/\1/g' Makefile

	# set CFLAGS
	sed -i "s^\(CFLAGS=\)-O^\1${CFLAGS}^g" Makefile

	# add search path for X11 libs.
	append-ldflags -L/usr/X11R6/lib

	# make gcc quiet.
	sed -i -e 's/^void$/int/' -e 's/^void\( main\)/int\1/g' xvt.c
}

src_compile() {
	# emake -j1 config
	emake || die
}

src_install() {
	dobin xvt
	doman xvt.1
	dodoc README COPYING
}
