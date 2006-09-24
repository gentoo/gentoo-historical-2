# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/scipy/scipy-0.5.1.ebuild,v 1.1 2006/09/24 07:29:56 dberkholz Exp $

inherit distutils flag-o-matic fortran

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
DESCRIPTION="Open source scientific tools for Python"
HOMEPAGE="http://www.scipy.org/"
LICENSE="BSD"

SLOT="0"
IUSE="fftw"
KEYWORDS="~amd64 ~ppc ~x86"

# did not use virtual/blas and virtual/lapack
# because doc says scipy needs to compile all libraries with the same compiler
RDEPEND=">=dev-lang/python-2.3.3
	>=dev-python/numpy-1.0_beta1
	sci-libs/blas-atlas
	sci-libs/blas-config
	sci-libs/lapack-config
	sci-libs/lapack-atlas
	fftw? ( =sci-libs/fftw-2.1* )"

DEPEND="${RDEPEND}"

# install doc claims fftw-2 is faster for complex ffts.
# wxwindows seems to have disapeared : ?
# f2py seems to be in numpy.

FORTRAN="g77 gfortran"

pkg_setup() {
	fortran_pkg_setup

	einfo "Checking active BLAS implementations for ATLAS."
	blas-config -p
	if ! blas-config -p | grep "F77 BLAS:" | grep -q -i atlas; then
		eerror "Your F77 BLAS profile is not set to the ATLAS implementation,"
		eerror "which is required by ${PN} to compile and run properly."
		eerror "Use: 'blas-config -f ATLAS' to activate ATLAS."
		echo
		bad_profile=1
	fi
	if ! blas-config -p | grep "C BLAS:" | grep -q -i atlas; then
		eerror "Your C BLAS profile is not set to the ATLAS implementation,"
		eerror "Which is required by ${PN} to compile and run properly."
		eerror "Use: 'blas-config -c ATLAS' to activate ATLAS."
		echo
		bad_profile=1
	fi
	einfo "Checking active LAPACK implementation for ATLAS."
	lapack-config -p
	if ! lapack-config -p | grep "F77 LAPACK:" | grep -q -i atlas; then
		eerror "Your F77 LAPACK profile is not set to the ATLAS implementation,"
		eerror "which is required by ${PN} to compile and run properly."
		eerror "Use: 'lapack-config ATLAS' to activate ATLAS."
		bad_profile=1
	fi
	if ! [ -z ${bad_profile} ]; then
		die "Active BLAS/LAPACK implementations are not ATLAS."
	fi

	# -Wl,-O1 breaks the compilation
	filter-ldflags -O1
	filter-ldflags -Wl,-O1
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	echo "[atlas]"  > site.cfg
	echo "include_dirs = /usr/include/atlas" >> site.cfg
	echo -n "library_dirs = /usr/$(get_libdir)/lapack:/usr/$(get_libdir):" \
			>> site.cfg
	if [ -d "/usr/$(get_libdir)/blas/threaded-atlas" ]; then
		echo "/usr/$(get_libdir)/blas/threaded-atlas" >> site.cfg
		echo "atlas_libs = lapack, blas, cblas, atlas, pthread" >> site.cfg
	else
		echo "/usr/$(get_libdir)/blas/atlas" >> site.cfg
		echo "atlas_libs = lapack, blas, cblas, atlas" >> site.cfg
	fi

	export FFTW3=None
	if use fftw; then
		echo "[fftw] " >> site.cfg
		echo "fftw_libs = rfftw, fftw" >> site.cfg
		echo "fftw_opt_libs = rfftw_threads, fftw_threads" >> site.cfg
	else
		export FFTW=None
	fi
}

src_compile() {
	# Map compilers to what scipy calls them
	local SCIPY_FC
	case "${FORTRANC}" in
		gfortran)
			SCIPY_FC="gnu95"
			;;
		g77)
			SCIPY_FC="gnu"
			;;
		g95)
			SCIPY_FC="g95"
			;;
		ifc|ifort)
			if use ia64; then
				SCIPY_FC="intele"
			else
				SCIPY_FC="intel"
			fi
			;;
		*)
			local msg="Invalid Fortran compiler \'${FORTRANC}\'"
			eerror "${msg}"
			die "${msg}"
			;;
	esac

	# http://projects.scipy.org/scipy/numpy/ticket/182
	# Can't set LDFLAGS
	unset LDFLAGS

	distutils_src_compile \
		config_fc \
		--fcompiler=${SCIPY_FC} \
		--opt="${CFLAGS}" \
		|| die "compilation failed"
}

src_install() {
	distutils_src_install
	dodoc *.txt
}
