# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/sed/sed-3.02.80-r3.ebuild,v 1.2 2001/12/21 02:53:18 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Super-useful stream editor"
SRC_URI="ftp://alpha.gnu.org/pub/gnu/sed/${P}.tar.gz"

DEPEND="virtual/glibc nls? ( sys-devel/gettext )"

RDEPEND="virtual/glibc"

src_compile() {
	local myconf
	[ -z "`use nls`" ] && myconf="--disable-nls"
	./configure --prefix=/usr --host=${CHOST} ${myconf} || die
	if [ -z "`use static`" ]
	then
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
		doinfo doc/sed.info
		doman doc/sed.1
		dodoc COPYING NEWS README* THANKS TODO AUTHORS BUGS ANNOUNCE
	else
		rm -rf ${D}/usr/share
	fi
}

