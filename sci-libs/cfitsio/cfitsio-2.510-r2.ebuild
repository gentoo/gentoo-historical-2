# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/cfitsio/cfitsio-2.510-r2.ebuild,v 1.2 2008/06/04 09:25:22 corsair Exp $

inherit eutils fortran autotools

DESCRIPTION="C and Fortran library for manipulating FITS files"
HOMEPAGE="http://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
SRC_URI="ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/${PN}${PV//.}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc64 ~sparc ~x86"
IUSE="doc fortran"

DEPEND="fortran? ( dev-lang/cfortran )"
RDEPEND=""

S="${WORKDIR}/${PN}"

pkg_setup() {
	if use fortran; then
		FORTRAN="gfortran g77 ifc"
		fortran_pkg_setup
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	# avoid internal cfortran
	if use fortran; then
		sed -i \
			-e 's:"cfortran.h":<cfortran.h>:' \
			f77_wrap.h || die "sed fortran failed"
		mv cfortran.h cfortran.h.disabled
	fi
	epatch "${FILESDIR}"/${P}-autotools.patch
	eautoreconf
}

src_compile() {
	econf $(use_enable fortran) || die "econf failed"
	emake || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc changes.txt README cfitsio.doc || die "dodoc failed"
	insinto /usr/share/doc/${PF}/examples
	doins cookbook.c testprog.c speed.c smem.c || die "install examples failed"
	use doc && dodoc cfitsio.ps quick.ps
	if use fortran; then
		doins cookbook.f || die "install cookbook failed"
		dodoc fitsio.doc
		use doc && dodoc fitsio.ps
	fi
}
