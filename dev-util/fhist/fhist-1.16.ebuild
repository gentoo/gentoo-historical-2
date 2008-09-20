# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/fhist/fhist-1.16.ebuild,v 1.3 2008/09/20 10:08:38 armin76 Exp $

DESCRIPTION="File history and comparison tools"
HOMEPAGE="http://fhist.sourceforge.net/fhist.html"
SRC_URI="http://fhist.sourceforge.net/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~mips ~ppc sparc x86"
IUSE="test"

RDEPEND="sys-devel/gettext
		sys-apps/groff"
DEPEND="${RDEPEND}
		test? ( app-arch/sharutils )
		sys-devel/bison"

src_compile() {
	econf || die "econf failed"
	emake -j1 || die "emake failed"
}

src_test() {
	make sure || die "src_test failed"
}

src_install () {
	make RPM_BUILD_ROOT="${D}" NLSDIR="${D}/usr/share/locale" \
		install || die "make install failed"

	dodoc lib/en/*.txt
	dodoc lib/en/*.ps

	# remove duplicate docs etc.
	rm -r "${D}"/usr/share/fhist

	dodoc MANIFEST README
}
