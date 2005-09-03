# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/icu/icu-3.2.ebuild,v 1.3 2005/09/03 19:44:36 sbriesen Exp $

DESCRIPTION="IBM Internationalization Components for Unicode"
SRC_URI="ftp://www-126.ibm.com/pub/icu/${PV}/${P}.tgz"
HOMEPAGE="http://ibm.com/software/globalization/icu/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~x86 ~amd64 alpha ppc s390 ia64 ppc64 ~sparc"
IUSE=""

DEPEND="virtual/libc"

S="${WORKDIR}/${PN}/source"

src_compile() {
	econf || die "econf failed"
	emake -j1 || die "emake failed"  # bug 102426
}

src_install () {
	make DESTDIR="${D}" install || die "make install failed"
	dohtml ../readme.html ../license.html
}
