# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/tkcvs/tkcvs-7.1.4.ebuild,v 1.4 2004/06/25 02:48:33 agriffis Exp $

MY_P=${PN}_${PV//./_}
S=${WORKDIR}/${MY_P}
DESCRIPTION="TkCVS is a Tcl/Tk-based graphical interface to CVS."
SRC_URI="http://www.twobarleycorns.net/${MY_P}.tar.gz"
HOMEPAGE="http://www.twobarleycorns.net/tkcvs.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64 ~sparc"

RDEPEND=">=dev-lang/tk-8.3
	dev-util/cvs
	sys-apps/diffutils"

src_compile() {
	echo "It's tcl, you don't need to compile.  ;)"
}

src_install() {
	dodir /usr/lib /usr/bin /usr/lib/tkcvs/ /usr/lib/tkcvs/bitmaps

	./doinstall.tcl -nox -finallib /usr/lib ${D}/usr || die

	# Move man pages to FHS compliant locations
	dodir /usr/share/man/man1
	mv ${D}/usr/man/man1/* ${D}/usr/share/man/man1
	rm -rf ${D}/usr/man

	insinto /usr/lib/tkcvs/bitmaps
	doins tkdiff/tkdiff.xbm

	# Add docs...this is important
	dodoc CHANGELOG COPYING FAQ README.tkcvs README.windows

	docinto tkdiff
	dodoc tkdiff/COPYING

	docinto tkcvs
	dodoc tkcvs/vendor.readme
}
