# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/mhash/mhash-0.8.18-r1.ebuild,v 1.8 2004/04/01 19:15:46 randy Exp $

DESCRIPTION="mhash is a library providing a uniform interface to a large number of hash algorithms."
SRC_URI="mirror://sourceforge/mhash/${P}.tar.gz"
HOMEPAGE="http://mhash.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc alpha hppa amd64 ia64 s390"

DEPEND="virtual/glibc"
RDEPEND=""

src_compile() {
	local myconf
	myconf="--enable-static --enable-shared"
	econf ${myconf} || die
	emake || die "make failure"
}

src_install() {
	dodir /usr/{bin,include,lib}
	einstall || die "install failure"

	dodoc AUTHORS COPYING INSTALL NEWS README TODO THANKS ChangeLog
	dodoc doc/*.txt doc/skid*
	prepalldocs
	cd doc && dohtml mhash.html || die "dohtml failed"
}
