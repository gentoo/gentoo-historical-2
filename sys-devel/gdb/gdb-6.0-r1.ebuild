# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gdb/gdb-6.0-r1.ebuild,v 1.2 2004/04/22 13:43:25 lv Exp $

inherit flag-o-matic eutils

DESCRIPTION="GNU debugger"
HOMEPAGE="http://sources.redhat.com/gdb/
		http://www.logix.cz/michal/devel/gdb-xfreemod"
SRC_URI="http://mirrors.rcn.net/pub/sourceware/gdb/releases/${P}.tar.bz2
		http://www.logix.cz/michal/devel/gdb-xfreemod/gdb-xfreemod-${PV}.diff"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc amd64 ~ppc64"
IUSE="nls"

DEPEND=">=sys-libs/ncurses-5.2-r2
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/gdb-6.0-threadver-aug2003.patch
	epatch ${FILESDIR}/gdb-6.0-coreutils.patch
	epatch ${FILESDIR}/gdb-6.0-info.patch
	cd ${S}/gdb
	epatch ${DISTDIR}/gdb-xfreemod-${PV}.diff
	epatch ${FILESDIR}/gdb-6.0-xfreemod-all.patch
	cd ${S}
	if [ "${ARCH}" = "sparc" ]; then
		epatch ${FILESDIR}/${PN}-5.3-sparc-nat-asm.patch
	fi
}

src_compile() {
	replace-flags -O? -O2
	econf `use_enable nls` || die
	make || die
}

src_install() {
	 make \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		install || die

	cd gdb/doc
	make \
		infodir=${D}/usr/share/info \
		install-info || die

	cd ${S}/bfd/doc
	make \
		infodir=${D}/usr/share/info \
		install-info || die

	cd ${S}

	# These includes and libs are in binutils already
	rm -f ${D}/usr/lib/libbfd.*
	rm -f ${D}/usr/lib/libiberty.*
	rm -f ${D}/usr/lib/libopcodes.*
	rm -f ${D}/usr/share/info/{bfd,configure,standards}.info*

	rm -rf ${D}/usr/include

	dodoc COPYING* README

	docinto gdb
	dodoc gdb/CONTRIBUTE gdb/COPYING* gdb/README \
		gdb/MAINTAINERS gdb/NEWS gdb/ChangeLog* \
		gdb/TODO

	docinto sim
	dodoc sim/ChangeLog sim/MAINTAINERS sim/README-HACKING

	docinto mmalloc
	dodoc mmalloc/COPYING.LIB mmalloc/MAINTAINERS \
		mmalloc/ChangeLog mmalloc/TODO
}
