# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/sys-apps/supersed/supersed-3.58.ebuild,v 1.1 2002/07/25 03:06:50 seemant Exp $

MY_P=${P/super/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="An enhanced version of sed which sports greater speed and the use of perl regular expressions than GNU sed."
SRC_URI="http://queen.rett.polimi.it/~paolob/seders/ssed/${MY_P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/sed/sed.html"
KEYWORDS="x86 ppc"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc nls? ( sys-devel/gettext )"

RDEPEND="virtual/glibc"

src_compile() {
	local myconf
	use nls ||  myconf="--disable-nls"
	use static \
		&& myconf="${myconf} --disable-html" \
		|| myconf="${myconf} --enable-html"
	
	econf \
		--program-suffix=-blah \
		${myconf} || die
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
		dodoc COPYING NEWS README* THANKS TODO AUTHORS BUGS
	else
		rm -rf ${D}/usr/share
	fi
}
