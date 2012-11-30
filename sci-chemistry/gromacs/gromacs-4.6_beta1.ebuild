# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/gromacs/gromacs-4.6_beta1.ebuild,v 1.1 2012/11/30 21:08:14 ottxor Exp $

EAPI=5

TEST_PV="4.0.4"
MANUAL_PV="4.6-beta1"

#to find external blas/lapack
CMAKE_MIN_VERSION="2.8.5-r2"

CMAKE_MAKEFILE_GENERATOR="ninja"

inherit bash-completion-r1 cmake-utils eutils fortran-2 multilib toolchain-funcs

SRC_URI="test? ( ftp://ftp.gromacs.org/pub/tests/gmxtest-${TEST_PV}.tgz )"

if [[ $PV = *9999* ]]; then
	EGIT_REPO_URI="git://git.gromacs.org/gromacs.git
		https://gerrit.gromacs.org/gromacs.git
		git://github.com/gromacs/gromacs.git
		http://repo.or.cz/r/gromacs.git"
	EGIT_BRANCH="release-4-6"
	inherit git-2
	PDEPEND="doc? ( ~app-doc/gromacs-manual-${PV} )"
else
	S="${WORKDIR}/${P//_/-}"
	SRC_URI="${SRC_URI} ftp://ftp.gromacs.org/pub/${PN}/${P//_/-}.tar.gz
		doc? (  ftp://ftp.gromacs.org/pub/manual/gromacs-manual-${MANUAL_PV}.pdf )"
fi

ACCE_IUSE="fkernels power6 sse2 sse41 avx128fma avx256"

DESCRIPTION="The ultimate molecular dynamics simulation package"
HOMEPAGE="http://www.gromacs.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="X blas cuda doc -double-precision +fftw gsl lapack
mpi openmm openmp +single-precision test +threads zsh-completion ${ACCE_IUSE}"

CDEPEND="
	X? (
		x11-libs/libX11
		x11-libs/libSM
		x11-libs/libICE
		)
	blas? ( virtual/blas )
	cuda? ( dev-util/nvidia-cuda-toolkit )
	fftw? ( sci-libs/fftw:3.0 )
	fkernels? ( !threads? ( !sse2? ( virtual/fortran ) ) )
	gsl? ( sci-libs/gsl )
	lapack? ( virtual/lapack )
	mpi? ( virtual/mpi )
	openmm? ( sci-libs/openmm[cuda,opencl] )"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}"

RESTRICT="test"

REQUIRED_USE="cuda? ( single-precision ) openmm? ( single-precision cuda )"

pkg_pretend() {
	[[ $(gcc-version) == "4.1" ]] && die "gcc 4.1 is not supported by gromacs"
	use openmp && ! tc-has-openmp && \
		die "Please switch to an openmp compatible compiler"
}

pkg_setup() {
	#notes/todos
	# -on apple: there is framework support
	# -mkl support
	# -there are power6 kernels
	if use fkernels; then
		if use threads; then
			ewarn "Fortran kernels and threads do not work together, disabling"
			ewarn "fortran kernels"
		else
			fortran-2_pkg_setup
		fi
	fi
}

src_prepare() {
	#add user patches from /etc/portage/patches/sci-chemistry/gromacs
	epatch_user

	GMX_DIRS=""
	use single-precision && GMX_DIRS+=" float"
	use double-precision && GMX_DIRS+=" double"
	#if neither single-precision nor double-precision is enabled
	#build at least default (single)
	[[ -z $GMX_DIRS ]] && GMX_DIRS+=" float"

	for x in ${GMX_DIRS}; do
		mkdir -p "${WORKDIR}/${P}_${x}" || die
		use test && cp -r "${WORKDIR}"/gmxtest "${WORKDIR}/${P}_${x}"
	done
}

src_configure() {
	local mycmakeargs_pre=( ) extra

	#go from slowest to fastest acceleration
	local acce="None"
	use fkernels && use !threads && acce="Fortran"
	use power6 && acce="Power6"
	use sse2 && acce="SSE2"
	use sse41 && acce="SSE4.1"
	use avx128fma && acce="AVX_128_FMA"
	use avx256 && acce="AVX_256"

	#to create man pages, build tree binaries are executed (bug #398437)
	[[ ${CHOST} = *-darwin* ]] && \
		extra+=" -DCMAKE_BUILD_WITH_INSTALL_RPATH=OFF"

	mycmakeargs_pre+=(
		-DGMX_FFT_LIBRARY=$(usex fftw fftw3 fftwpack)
		$(cmake-utils_use X GMX_X11)
		$(cmake-utils_use blas GMX_EXTERNAL_BLAS)
		$(cmake-utils_use gsl GMX_GSL)
		$(cmake-utils_use lapack GMX_EXTERNAL_LAPACK)
		$(cmake-utils_use openmp GMX_OPENMP)
		-DGMX_DEFAULT_SUFFIX=off
		-DGMX_ACCELERATION="$acce"
		-DGMXLIB="$(get_libdir)"
	    -DGMX_VMD_PLUGIN_PATH="${EPREFIX}/usr/$(get_libdir)/vmd/plugins/*/molfile/"
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
			$(cmake-utils_use threads GMX_THREAD_MPI) ${cuda}
			-DGMX_BINARY_SUFFIX="${suffix}" -DGMX_LIBS_SUFFIX="${suffix}" )
		CMAKE_BUILD_DIR="${WORKDIR}/${P}_${x}" cmake-utils_src_configure
		if [[ ${x} = float ]] && use openmm; then
			einfo "Configuring for openmm build"
			mycmakeargs=( ${mycmakeargs_pre[@]} ${p} -DGMX_MPI=OFF
				-DGMX_THREAD_MPI=OFF -DGMX_GPU=OFF -DGMX_OPENMM=ON
				-DGMX_BINARY_SUFFIX="openmm" -DGMX_LIBS_SUFFIX="openmm" )
			CMAKE_BUILD_DIR="${WORKDIR}/${P}_openmm" \
				OPENMM_ROOT_DIR="${EPREFIX}/usr" cmake-utils_src_configure
		fi
		use mpi || continue
		einfo "Configuring for ${x} precision with mpi"
		mycmakeargs=( ${mycmakeargs_pre[@]} ${p} -DGMX_THREAD_MPI=OFF
			-DGMX_MPI=ON ${cuda}
			-DGMX_BINARY_SUFFIX="_mpi${suffix}" -DGMX_LIBS_SUFFIX="_mpi${suffix}" )
		CMAKE_BUILD_DIR="${WORKDIR}/${P}_${x}_mpi" CC="mpicc" cmake-utils_src_configure
	done
}

src_compile() {
	for x in ${GMX_DIRS}; do
		einfo "Compiling for ${x} precision"
		CMAKE_BUILD_DIR="${WORKDIR}/${P}_${x}"\
			cmake-utils_src_compile
		if [[ ${x} = float ]] && use openmm; then
			einfo "Compiling for openmm build"
			CMAKE_BUILD_DIR="${WORKDIR}/${P}_openmm"\
				cmake-utils_src_compile mdrun
		fi
		use mpi || continue
		einfo "Compiling for ${x} precision with mpi"
		CMAKE_BUILD_DIR="${WORKDIR}/${P}_${x}_mpi"\
			cmake-utils_src_compile mdrun
	done
}

src_test() {
	for x in ${GMX_DIRS}; do
		local oldpath="${PATH}"
		export PATH="${WORKDIR}/${P}_${x}/src/kernel:${S}-{x}/src/tools:${PATH}"
		cd "${WORKDIR}/${P}_${x}"
		emake -j1 tests || die "${x} Precision test failed"
		export PATH="${oldpath}"
	done
}

src_install() {
	for x in ${GMX_DIRS}; do
		CMAKE_BUILD_DIR="${WORKDIR}/${P}_${x}" \
			cmake-utils_src_install
		if [[ ${x} = float ]] && use openmm; then
			CMAKE_BUILD_DIR="${WORKDIR}/${P}_openmm" \
				DESTDIR="${D}" cmake-utils_src_make install-mdrun
		fi
		use mpi || continue
		CMAKE_BUILD_DIR="${WORKDIR}/${P}_${x}_mpi" \
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
			dodoc "${DISTDIR}/gromacs-manual-${MANUAL_PV}.pdf"
		fi
	fi
	rm -rf "${ED}usr/share/gromacs/html/"
}

pkg_postinst() {
	einfo
	einfo  "Please read and cite:"
	einfo  "Gromacs 4, J. Chem. Theory Comput. 4, 435 (2008). "
	einfo  "http://dx.doi.org/10.1021/ct700301q"
	einfo
	einfo  $(g_luck)
	einfo  "For more Gromacs cool quotes (gcq) add g_luck to your .bashrc"
	einfo
	elog  "Gromacs can use sci-chemistry/vmd to read additional file formats"
}
