# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/busybox/busybox-0.50.ebuild,v 1.13 2003/02/13 15:49:57 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Utilities for rescue and embedded systems"
SRC_URI="ftp://oss.lineo.com/busybox/${P}.tar.gz"
HOMEPAGE="http://busybox.lineo.com/"
KEYWORDS="x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	cp ${FILESDIR}/Config.h ${S}/Config.h
}

src_compile() {
	export OPT="`echo $CFLAGS|sed 's:.*\(-O.\).*:\1:'`"
	export CFLAGS_EXTRA=${CFLAGS/-O?/}
	unset CFLAGS
	echo $CFLAGS_EXTRA $OPT
	make CFLAGS_EXTRA="${CFLAGS_EXTRA}" OPTIMIZATION=$OPT || die
}

src_install() {
	into /    
	dobin busybox
	into /usr
	dodoc AUTHORS Changelog LICENSE README TODO
	cd docs
	doman *.1
	docinto txt
	dodoc *.txt
	docinto sgml
	dodoc *.sgml
	docinto pod
	dodoc *.pod

	cd busybox.lineo.com
	docinto html
	dodoc *.html
	docinto html/images
	dodoc images/*
}
