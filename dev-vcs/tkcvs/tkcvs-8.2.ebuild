# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/tkcvs/tkcvs-8.2.ebuild,v 1.1 2010/06/21 09:52:13 jlec Exp $

inherit eutils

MY_P=${PN}_${PV//./_}
DESCRIPTION="TkCVS is a Tcl/Tk-based graphical interface to CVS."
SRC_URI="http://www.twobarleycorns.net/${MY_P}.tar.gz"
HOMEPAGE="http://www.twobarleycorns.net/tkcvs.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND=">=dev-lang/tk-8.4"
RDEPEND="${DEPEND}
	dev-vcs/cvs
	dev-util/subversion
	sys-apps/diffutils
	dev-util/tkdiff"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -e "/set MANDIR/s/man man1/share man man1/" \
		-e "/set LIBDIR/s/lib/$(get_libdir)/" \
		-i doinstall.tcl || die
}

src_install() {
	# bug 66030
	unset DISPLAY
	./doinstall.tcl -nox "${D}"/usr || die

	# dev-tcktk/tkdiff
	rm "${D}"/usr/bin/tkdiff

	# Add docs...this is important
	dodoc CHANGELOG FAQ
}
