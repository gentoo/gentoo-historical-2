# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-libs/zthread/zthread-1.5.3.ebuild,v 1.5 2002/08/01 18:46:28 seemant Exp $

S=${WORKDIR}/ZThread-${PV}

DESCRIPTION="A Platform-Independent Object-Oriented Threading Architecture"
SRC_URI="mirror://sourceforge/zthread/ZThread-${PV}.tar.gz"
HOMEPAGE="http://www.cs.buffalo.edu/~crahen/projects/zthread/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="virtual/glibc"

src_compile() {
	local myconf
	if [ "${DEBUG}" ]
	then
		myconf="--enable-debug=yes"
	else
		myconf="--enable-debug=no"
	fi

	econf ${myconf} || die "./configure failed"

	emake || die
}

src_install () {
	make prefix=${D}/usr install || die
	dodoc AUTHORS ChangeLog COPYING README* INSTALL NEWS TODO THANK.YOU
}
