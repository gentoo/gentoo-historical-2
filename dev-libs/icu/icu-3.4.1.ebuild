# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/icu/icu-3.4.1.ebuild,v 1.3 2006/09/15 20:18:33 dang Exp $

DESCRIPTION="IBM Internationalization Components for Unicode"
SRC_URI="ftp://ftp.software.ibm.com/software/globalization/icu/${PV}/${P}.tgz"
HOMEPAGE="http://ibm.com/software/globalization/icu/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~amd64 ~ppc ~ppc-macos ~sparc ~x86"
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
