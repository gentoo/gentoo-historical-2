# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/sed/sed-4.0.5.ebuild,v 1.8 2003/02/24 22:34:59 dragon Exp $

DESCRIPTION="Super-useful stream editor"
SRC_URI="ftp://ftp.gnu.org/pub/gnu/sed/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/sed/sed.html"

KEYWORDS="x86 ppc sparc alpha hppa arm mips"
SLOT="0"
LICENSE="GPL-2"
IUSE="nls static build"

DEPEND="virtual/glibc
	nls? ( sys-devel/gettext )"
RDEPEND="virtual/glibc"

src_compile() {
	econf `use_enable nls` || die
	if [ `use static` ] ; then
		emake || die
	else
		emake LDFLAGS=-static || die
	fi
}

src_install() {
	into /
	dobin sed/sed
	dodir /usr/bin
	dosym ../../bin/sed /usr/bin/sed
	if [ -z "`use build`" ]
	then
		into /usr
		doinfo doc/sed.info*
		doman doc/sed.1
		dodoc COPYING NEWS README* THANKS TODO AUTHORS BUGS ANNOUNCE ChangeLog
	else
		rm -rf ${D}/usr/share
	fi
}
