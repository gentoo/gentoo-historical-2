# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/netcdf/netcdf-4.1.1-r3.ebuild,v 1.1 2010/12/06 12:47:00 xarthisius Exp $

EAPI="3"

inherit autotools autotools-utils

DESCRIPTION="Scientific library and interface for array oriented data access"
HOMEPAGE="http://www.unidata.ucar.edu/software/netcdf/"
SRC_URI="ftp://ftp.unidata.ucar.edu/pub/netcdf/${P}.tar.gz"

LICENSE="UCAR-Unidata"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="cxx dap doc fortran hdf5 static-libs szip"

RDEPEND="dap? ( net-misc/curl )
	hdf5? ( >=sci-libs/hdf5-1.8[zlib,szip?,fortran?] )"

DEPEND="${RDEPEND}
	>=sys-devel/libtool-2.2
	doc? ( virtual/latex-base )
	fortran? ( dev-lang/cfortran )"

DOCS=(README RELEASE_NOTES)

PATCHES=(
	"${FILESDIR}"/${P}-parallel-build.patch
	"${FILESDIR}"/${P}-implicits.patch
	"${FILESDIR}"/${P}-mpi-fix.patch
)

pkg_setup() {
	if use hdf5 && has_version sci-libs/hdf5[mpi]; then
		export CC=mpicc
		if use cxx; then
			export CXX=mpicxx
		fi
		if use fortran; then
			export FC=mpif90
			export F77=mpif77
		fi
	fi
}

src_prepare() {
	# use system cfortran
	rm -f fortran/cfortran.h || die
	# we don't build udunits and libcf
	sed -i -e '/udunits libcf/d' configure.ac || die
	if ! use doc; then
		sed -i -e "/\$(NC_TEST4)/ s/man4//" Makefile.am || die
	fi
	autotools-utils_src_prepare
	eautoreconf
}

src_configure() {
	local myconf
	if use hdf5; then
		myconf="--with-hdf5=${EPREFIX}/usr --with-zlib=${EPREFIX}/usr"
		use szip && myconf="${myconf} --with-szlib=${EPREFIX}/usr"
	fi

	myeconfargs=(
		--enable-shared
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable dap)
		$(use_enable static-libs static)
		$(use_enable fortran f77)
		$(use_enable fortran f90)
		$(use_enable cxx)
		$(use_enable fortran separate-fortran)
		$(use_enable hdf5 netcdf-4)
		${myconf}
	)
	autotools-utils_src_configure
}

src_compile() {
	# hack to allow parallel build
	if use doc; then
		autotools-utils_src_compile pdf
		autotools-utils_src_compile -j1 -C man4
	fi
	autotools-utils_src_compile
}
