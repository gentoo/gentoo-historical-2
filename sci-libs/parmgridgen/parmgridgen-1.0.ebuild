# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/parmgridgen/parmgridgen-1.0.ebuild,v 1.1 2009/04/25 16:04:22 patrick Exp $

inherit eutils autotools

MYP=ParMGridGen-${PV}

DESCRIPTION="Software for parallel (mpi) generating coarse grids"
HOMEPAGE="http://www-users.cs.umn.edu/~moulitsa/software.html"
SRC_URI="http://www-users.cs.umn.edu/~moulitsa/download/${MYP}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="as-is"
SLOT="0"
IUSE=""

DEPEND="virtual/mpi"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MYP}

pkg_setup(){
	export CC=mpicc
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-autotools.patch"
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README Doc/*.pdf || die "dodoc failed"
}
