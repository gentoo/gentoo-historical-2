# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/spim/spim-6.5.ebuild,v 1.1 2003/02/04 06:02:08 lostlogic Exp $

IUSE="X"

HOMEPAGE="http://www.cs.wisc.edu/~larus/spim.html"
SRC_URI="http://www.cs.wisc.edu/~larus/SPIM/spim.tar.gz"
DESCRIPTION="MIPS Simulator"
SLOT="0"
KEYWORDS="~x86"
LICENSE="as-is"
S=${WORKDIR}/${P}

src_compile() {
	pwd -P
	./Configure || die "Configure script failed"

	sed -e "s:\(BIN_DIR = \).*$:\1/usr/bin:" \
	    -e "s:\(MAN_DIR = \).*$:\1/usr/share/bin:" \
	    -e "s:\(TRAP_DIR = \).*$:\1/usr/sbin:" \
	    Makefile > Makefile.comp
	cp Makefile.comp Makefile

	make ${MAKEOPTS} spim || die "make spim failed"
	[ `use X` ] && make ${MAKEOPTS} xspim || die "make xspim failed"
}

src_install() {
	sed -e "s:\(BIN_DIR = \).*$:\1${D}usr/bin:" \
	    -e "s:\(MAN_DIR = \).*$:\1${D}usr/share/bin:" \
	    -e "s:\(TRAP_DIR = \).*$:\1${D}usr/sbin:" \
	    Makefile > Makefile.inst
	cp Makefile.inst Makefile

	dodir /usr/sbin

	dodoc BLURB README VERSION CangeLog Documentation/*

	make install || die "Install failed"
}

pkg_postinst() {
	cd ${S}
	cp Makefile.comp Makefile
	make test || die "Test failed"

}
