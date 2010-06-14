# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/cfitsio/cfitsio-3.250.ebuild,v 1.1 2010/06/14 18:08:25 bicatali Exp $

EAPI=2
inherit eutils autotools

DESCRIPTION="C and Fortran library for manipulating FITS files"
HOMEPAGE="http://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
SRC_URI="ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/${PN}${PV//.}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc fortran threads"

DEPEND="fortran? ( dev-lang/cfortran )"
RDEPEND=""

S="${WORKDIR}/${PN}"

src_prepare() {
	# avoid internal cfortran
	if use fortran; then
		mv cfortran.h cfortran.h.disabled
		ln -s /usr/include/cfortran.h .
	fi
	epatch "${FILESDIR}"/${P}-autotools.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable threads) \
		$(use_enable fortran)
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc changes.txt README cfitsio.doc || die "dodoc failed"
	insinto /usr/share/doc/${PF}/examples
	doins cookbook.c testprog.c speed.c smem.c || die "install examples failed"
	use fortran && dodoc fitsio.doc && doins cookbook.f
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins quick.ps cfitsio.ps fpackguide.pdf
		use fortran && doins fitsio.ps
	fi
}
