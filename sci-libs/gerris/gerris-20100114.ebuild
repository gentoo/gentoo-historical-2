# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/gerris/gerris-20100114.ebuild,v 1.3 2011/03/02 19:59:23 jlec Exp $

EAPI=2

inherit autotools eutils

DESCRIPTION="The Gerris Flow Solver"
LICENSE="GPL-2"
HOMEPAGE="http://gfs.sourceforge.net/"
SRC_URI="mirror://sourceforge/gfs/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples mpi"

RDEPEND="dev-libs/glib:2
	sci-libs/netcdf
	sci-libs/gsl
	sci-libs/gts
	sci-libs/proj
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

# test assume it is installed
RESTRICT="test"

S="${WORKDIR}"/${PN}-snapshot-100114

src_prepare() {
	epatch "${FILESDIR}"/${P}-autotools.patch
	eautoreconf
}

src_configure() {
	econf $(use_enable mpi)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake nstall failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		rm -f doc/examples/*.pyc || die "Failed to remove python object"
		doins -r doc/examples/* || die
	fi
}
