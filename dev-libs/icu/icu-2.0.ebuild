# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-libs/icu/icu-2.0.ebuild,v 1.6 2002/08/14 11:52:27 murphy Exp $

S=${WORKDIR}/${PN}/source
DESCRIPTION="IBM Internationalization Components for Unicode"
SRC_URI="http://oss.software.ibm.com/icu/download/${PV}/${P}.tgz"
HOMEPAGE="http://oss.software.ibm.com/icu/index.html"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 sparc sparc64"

DEPEND="virtual/glibc"

src_compile() {
	econf --enable-layout || die
	emake || die "emake failed"
}

src_install () {
	make DESTDIR=${D} install || die "make install failed"
	dohtml ../readme.html ../license.html
}
