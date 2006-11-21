# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/paraview/paraview-2.4.4.ebuild,v 1.2 2006/11/21 02:18:09 markusle Exp $

inherit distutils eutils flag-o-matic toolchain-funcs versionator python

DESCRIPTION="ParaView is a powerful scientific data visualization application"
HOMEPAGE="http://www.paraview.org"
SRC_URI="http://www.${PN}.org/files/v2.4/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~x86"
SLOT="0"
IUSE="mpi python hdf5 doc examples ffmpeg threads"
RDEPEND="hdf5? ( sci-libs/hdf5 )
	doc? ( app-doc/doxygen )
	mpi? ( sys-cluster/mpich )
	python? ( >=dev-lang/python-2.0 )
	ffmpeg? ( media-video/ffmpeg )
	media-libs/libpng
	media-libs/jpeg
	media-libs/tiff
	dev-libs/expat
	sys-libs/zlib
	media-libs/freetype
	virtual/opengl
	dev-lang/tcl
	dev-lang/tk
	|| ( x11-libs/libXmu virtual/x11 )"

DEPEND="${RDEPEND}
		>=dev-util/cmake-2.4.3"

PVLIBDIR="$(get_libdir)/${PN}-$(get_version_component_range 1-2)"
BUILDDIR="${WORKDIR}/build"

src_unpack() {
	unpack ${A}
	mkdir "${BUILDDIR}" || die "Failed to generate build directory"
	cd "${S}"
	epatch "${FILESDIR}"/${P}-hdf5-zlib.patch
	epatch "${FILESDIR}"/${P}-png.patch
}

src_compile() {
	cd "${BUILDDIR}"
	local CMAKE_VARIABLES=""
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DPV_INSTALL_LIB_DIR:PATH=/${PVLIBDIR}"
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DCMAKE_SKIP_RPATH:BOOL=YES"
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DCMAKE_INSTALL_PREFIX:PATH=/usr"
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DBUILD_SHARED_LIBS:BOOL=ON"
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_SYSTEM_FREETYPE:BOOL=ON"
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_SYSTEM_JPEG:BOOL=ON"
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_SYSTEM_PNG:BOOL=ON"
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_SYSTEM_TIFF:BOOL=ON"
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_SYSTEM_ZLIB:BOOL=ON"
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_SYSTEM_EXPAT:BOOL=ON"

	if use hdf5; then
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DPARAVIEW_USE_SYSTEM_HDF5:BOOL=ON"
	fi

	if use mpi; then
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_MPI:BOOL=ON"
	fi

	if use python; then
		python_version
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DPARAVIEW_WRAP_PYTHON:BOOL=ON"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DPYTHON_INCLUDE_PATH:PATH=/usr/include/python${PYVER}"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DPYTHON_LIBRARY:PATH=/usr/$(get_libdir)/libpython${PYVER}.so"
	fi

	if use ffmpeg; then
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_FFMPEG_ENCODER:BOOL=ON"
	else
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_FFMPEG_ENCODER:BOOL=OFF"
	fi

	use doc && CMAKE_VARIABLES="${CMAKE_VARIABLES} -DBUILD_DOCUMENTATION:BOOL=ON"

	if use examples; then
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DBUILD_EXAMPLES:BOOL=ON"
	else
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DBUILD_EXAMPLES:BOOL=OFF"
	fi

	if use threads; then
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DCMAKE_USE_PTHREADS:BOOL=ON"
	else
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DCMAKE_USE_PTHREADS:BOOL=OFF"
	fi

	cmake ${CMAKE_VARIABLES} ${S} \
		|| die "cmake configuration failed"

	emake || die "emake failed"

}

src_install() {
	cd ${BUILDDIR}
	make DESTDIR=${D} install || die "make install failed"

	# set up the environment
	echo "LDPATH=/usr/${PVLIBDIR}" >> ${T}/40${PN}
	doenvd ${T}/40${PN}
}
