# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gdb/gdb-6.2.ebuild,v 1.1 2004/08/08 23:59:09 solar Exp $

inherit flag-o-matic eutils

DESCRIPTION="GNU debugger"
HOMEPAGE="http://sources.redhat.com/gdb/"
SRC_URI="http://mirrors.rcn.net/pub/sourceware/gdb/releases/${P}.tar.bz2
	mirror://gentoo/gdb-6.1-hppa-01.patch.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~alpha ~arm hppa ~ppc64 ~amd64"
IUSE="nls"

DEPEND=">=sys-libs/ncurses-5.2-r2
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}; cd ${S}
	epatch ${FILESDIR}/gdb-6.1-uclibc.patch
	strip-linguas -u bfd/po opcodes/po
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

	dodoc README
	docinto gdb
	dodoc gdb/CONTRIBUTE gdb/README \
		gdb/MAINTAINERS gdb/NEWS gdb/ChangeLog* \
		gdb/TODO
	docinto sim
	dodoc sim/ChangeLog sim/MAINTAINERS sim/README-HACKING
	docinto mmalloc
	dodoc mmalloc/MAINTAINERS mmalloc/ChangeLog mmalloc/TODO
}
