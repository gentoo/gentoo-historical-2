# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/umfpack/umfpack-5.2.0.ebuild,v 1.14 2011/06/21 14:45:09 jlec Exp $

inherit autotools eutils fortran-2

MY_PN=UMFPACK

DESCRIPTION="Unsymmetric multifrontal sparse LU factorization library"
HOMEPAGE="http://www.cise.ufl.edu/research/sparse/umfpack"
SRC_URI="http://www.cise.ufl.edu/research/sparse/${PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86"
IUSE="doc"
RDEPEND="
	virtual/fortran
	virtual/blas
	sci-libs/amd"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/${MY_PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-autotools.patch
	eautoreconf
}

src_compile() {
	econf \
		--with-blas="$(pkg-config --libs blas)" \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README.txt Doc/ChangeLog || die "dodoc failed"
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins Doc/*.pdf || die "doins failed"
	fi
}
