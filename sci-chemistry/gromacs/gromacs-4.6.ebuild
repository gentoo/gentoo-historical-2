# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/gromacs/gromacs-4.6.ebuild,v 1.1 2013/01/19 21:49:38 ottxor Exp $

EAPI=5

TEST_PV="4.6"
MANUAL_PV="4.6"

CMAKE_MAKEFILE_GENERATOR="ninja"

inherit bash-completion-r1 cmake-utils eutils multilib toolchain-funcs

if [[ $PV = *9999* ]]; then
	EGIT_REPO_URI="git://git.gromacs.org/gromacs.git
		https://gerrit.gromacs.org/gromacs.git
		git://github.com/gromacs/gromacs.git
		http://repo.or.cz/r/gromacs.git"
	EGIT_BRANCH="release-4-6"
	inherit git-2
	PDEPEND="doc? ( ~app-doc/${PN}-manual-${PV} )"
else
	SRC_URI="ftp://ftp.gromacs.org/pub/${PN}/${P}.tar.gz
		doc? ( ftp://ftp.gromacs.org/pub/manual/manual-${MANUAL_PV}.pdf -> ${PN}-manual-${MANUAL_PV}.pdf )
		test? ( http://${PN}.googlecode.com/files/regressiontests-${TEST_PV}.tar.gz )"
fi

ACCE_IUSE="sse2 sse41 avx128fma avx256"

DESCRIPTION="The ultimate molecular dynamics simulation package"
HOMEPAGE="http://www.gromacs.org/"

# see COPYING for details
# http://repo.or.cz/w/gromacs.git/blob/HEAD:/COPYING
#        base,    vmd plugins, fftpack from numpy,  blas/lapck from netlib,        memtestG80 library,  mpi_thread lib
LICENSE="LGPL-2.1 UoI-NCSA !mkl? ( !fftw? ( BSD ) !blas? ( BSD ) !lapack? ( BSD ) ) cuda? ( LGPL-3 ) threads? ( BSD )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="X blas cuda doc -double-precision +fftw gsl lapack mkl mpi +offensive openmp +single-precision test +threads zsh-completion ${ACCE_IUSE}"

CDEPEND="
	X? (
		x11-libs/libX11
		x11-libs/libSM
		x11-libs/libICE
		)
	blas? ( virtual/blas )
	cuda? ( dev-util/nvidia-cuda-toolkit )
	fftw? ( sci-libs/fftw:3.0 )
	gsl? ( sci-libs/gsl )
	lapack? ( virtual/lapack )
	mkl? ( sci-libs/mkl )
	mpi? ( virtual/mpi )"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}"

REQUIRED_USE="
	|| ( single-precision double-precision )
	cuda? ( single-precision )
	mkl? ( !blas !fftw !lapack )"

pkg_pretend() {
	[[ $(gcc-version) == "4.1" ]] && die "gcc 4.1 is not supported by gromacs"
	use openmp && ! tc-has-openmp && \
		die "Please switch to an openmp compatible compiler"
}

src_prepare() {
	#notes/todos
	# -on apple: there is framework support

	#add user patches from /etc/portage/patches/sci-chemistry/gromacs
	epatch_user

	GMX_DIRS=""
	use single-precision && GMX_DIRS+=" float"
	use double-precision && GMX_DIRS+=" double"

	if use test; then
		for x in ${GMX_DIRS}; do
			mkdir -p "${WORKDIR}/${P}_${x}" || die
			cp -al "${WORKDIR}/regressiontests-${TEST_PV}" "${WORKDIR}/${P}_${x}/tests" || die
		done
	fi
}

src_configure() {
	local mycmakeargs_pre=( ) extra fft_opts=( )

	#go from slowest to fastest acceleration
	local acce="None"
	use sse2 && acce="SSE2"
	use sse41 && acce="SSE4.1"
	use avx128fma && acce="AVX_128_FMA"
	use avx256 && acce="AVX_256"

	#to create man pages, build tree binaries are executed (bug #398437)
	[[ ${CHOST} = *-darwin* ]] && \
		extra+=" -DCMAKE_BUILD_WITH_INSTALL_RPATH=OFF"

	if use fftw; then
		fft_opts=( -DGMX_FFT_LIBRARY=fftw3 )
	elif use mkl && has_version "=sci-libs/mkl-10*"; then
		fft_opts=( -DGMX_FFT_LIBRARY=mkl
			-DMKL_INCLUDE_DIR="${MKLROOT}/include"
			-DMKL_LIBRARIES="$(echo /opt/intel/mkl/10.0.5.025/lib/*/libmkl.so);$(echo /opt/intel/mkl/10.0.5.025/lib/*/libiomp*.so)"
		)
	elif use mkl; then
		local bits=$(get_libdir)
		fft_opts=( -DGMX_FFT_LIBRARY=mkl
			-DMKL_INCLUDE_DIR="$(echo /opt/intel/*/mkl/include)"
			-DMKL_LIBRARIES="$(echo /opt/intel/*/mkl/lib/*${bits/lib}/libmkl_rt.so)"
		)
	else
		fft_opts=( -DGMX_FFT_LIBRARY=fftpack )
	fi

	mycmakeargs_pre+=(
		"${fft_opts[@]}"
		$(cmake-utils_use X GMX_X11)
		$(cmake-utils_use blas GMX_EXTERNAL_BLAS)
		$(cmake-utils_use gsl GMX_GSL)
		$(cmake-utils_use lapack GMX_EXTERNAL_LAPACK)
		$(cmake-utils_use openmp GMX_OPENMP)
		$(cmake-utils_use offensive GMX_COOL_QUOTES)
		-DGMX_DEFAULT_SUFFIX=off
		-DGMX_ACCELERATION="$acce"
		-DGMXLIB="$(get_libdir)"
		-DGMX_VMD_PLUGIN_PATH="${EPREFIX}/usr/$(get_libdir)/vmd/plugins/*/molfile/"
		-DGMX_PREFIX_LIBMD=ON
		-DGMX_X86_AVX_GCC_MASKLOAD_BUG=OFF
		-DGMX_USE_GCC44_BUG_WORKAROUND=OFF
		${extra}
	)

	for x in ${GMX_DIRS}; do
		einfo "Configuring for ${x} precision"
		local suffix=""
		#if we build single and double - double is suffixed
		use double-precision && use single-precision && \
			[[ ${x} = "double" ]] && suffix="_d"
		local p
		[[ ${x} = "double" ]] && p="-DGMX_DOUBLE=ON" || p="-DGMX_DOUBLE=OFF"
		local cuda=$(cmake-utils_use cuda GMX_GPU)
		[[ ${x} = "double" ]] && use cuda && cuda="-DGMX_GPU=OFF"
		mycmakeargs=( ${mycmakeargs_pre[@]} ${p} -DGMX_MPI=OFF
			$(cmake-utils_use threads GMX_THREAD_MPI) ${cuda} -DGMX_OPENMM=OFF
			"$(use test && echo -DREGRESSIONTEST_PATH="${WORKDIR}/${P}_${x}/tests")"
			-DGMX_BINARY_SUFFIX="${suffix}" -DGMX_LIBS_SUFFIX="${suffix}" )
		BUILD_DIR="${WORKDIR}/${P}_${x}" cmake-utils_src_configure
		use mpi || continue
		einfo "Configuring for ${x} precision with mpi"
		mycmakeargs=( ${mycmakeargs_pre[@]} ${p} -DGMX_THREAD_MPI=OFF
			-DGMX_MPI=ON ${cuda} -DGMX_OPENMM=OFF
			-DGMX_BINARY_SUFFIX="_mpi${suffix}" -DGMX_LIBS_SUFFIX="_mpi${suffix}" )
		BUILD_DIR="${WORKDIR}/${P}_${x}_mpi" CC="mpicc" cmake-utils_src_configure
	done
}

src_compile() {
	for x in ${GMX_DIRS}; do
		einfo "Compiling for ${x} precision"
		BUILD_DIR="${WORKDIR}/${P}_${x}"\
			cmake-utils_src_compile
		use mpi || continue
		einfo "Compiling for ${x} precision with mpi"
		BUILD_DIR="${WORKDIR}/${P}_${x}_mpi"\
			cmake-utils_src_compile mdrun
	done
}

src_test() {
	for x in ${GMX_DIRS}; do
		BUILD_DIR="${WORKDIR}/${P}_${x}"\
			cmake-utils_src_make check
	done
}

src_install() {
	for x in ${GMX_DIRS}; do
		BUILD_DIR="${WORKDIR}/${P}_${x}" \
			cmake-utils_src_install
		use mpi || continue
		BUILD_DIR="${WORKDIR}/${P}_${x}_mpi" \
			DESTDIR="${D}" cmake-utils_src_make install-mdrun
	done

	rm -f "${ED}"/usr/bin/GMXRC*

	newbashcomp "${ED}"/usr/bin/completion.bash ${PN}
	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		newins "${ED}"/usr/bin/completion.zsh _${PN}
	fi
	rm -f "${ED}"/usr/bin/completion.*

	cd "${S}"
	dodoc AUTHORS INSTALL* README*
	if use doc; then
		dohtml -r "${ED}usr/share/gromacs/html/"
		if [[ $PV = *9999* ]]; then
			insinto /usr/share/gromacs
			doins "admin/programs.txt"
			ls -1 "${ED}"/usr/bin | sed -e '/_d$/d' > "${T}"/programs.list
			doins "${T}"/programs.list
		else
			dodoc "${DISTDIR}/${PN}-manual-${MANUAL_PV}.pdf"
		fi
	fi
	rm -rf "${ED}usr/share/gromacs/html/"
}

pkg_postinst() {
	einfo
	einfo  "Please read and cite:"
	einfo  "Gromacs 4, J. Chem. Theory Comput. 4, 435 (2008). "
	einfo  "http://dx.doi.org/10.1021/ct700301q"
	if use offensive; then
		einfo
		einfo  $(g_luck)
		einfo  "For more Gromacs cool quotes (gcq) add g_luck to your .bashrc"
	fi
	einfo
	elog  "Gromacs can use sci-chemistry/vmd to read additional file formats"
}
