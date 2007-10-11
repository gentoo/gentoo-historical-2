# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/blas-atlas/blas-atlas-3.7.11.ebuild,v 1.21 2007/10/11 17:03:20 bicatali Exp $

inherit eutils toolchain-funcs fortran

DESCRIPTION="Automatically Tuned Linear Algebra Software BLAS implementation"
HOMEPAGE="http://math-atlas.sourceforge.net/"
MY_PN=${PN/blas-/}
MY_PV=3.6.0
SRC_URI="mirror://sourceforge/math-atlas/${MY_PN}${PV}.tar.bz2
		mirror://gentoo/atlas${MY_PV}-shared-libs.3.patch.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"
IUSE="doc"

RDEPEND="sci-libs/blas-config"
DEPEND="${RDEPEND}
	>=sys-devel/libtool-1.5"

S="${WORKDIR}/ATLAS"
RPATH="${DESTTREE}/$(get_libdir)/blas"
FORTRAN="g77 gfortran"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/unbuffered.patch
	epatch "${FILESDIR}"/${PV}-allow-any-gcc-version.patch
	epatch "${DISTDIR}"/atlas3.6.0-shared-libs.3.patch.bz2
	epatch "${FILESDIR}"/${PV}-ppc-configure.patch
	sed -i \
		-e "s:ASM:ASM VOLATILE:" \
		include/contrib/camm_dpa.h \
		|| die "sed failed to fix clobbering"

	sed -i \
		-e "s:\(\t./xconfig\):\1 -m $(tc-getCC) -c $(tc-getCC) -f ${FORTRANC}:g" \
		"${S}"/Makefile \
		|| die "Failed to fix compilers"

	if [[ $(gcc-major-version) -ge 4 ]]; then
		einfo "Updating Makefiles for gcc-4"
		sed -i \
			-e "s:g2c:gfortran:g" \
			"${S}"/Make.top \
			"${S}"/makes/Make.lib \
			|| die "Failed to update for gcc-4"
	fi

	# make sure shared libs link against proper libraries
	if [[ ${FORTRANC} == "gfortran" ]]; then
		libs="-lpthread -lgfortran"
	else
		libs="-lpthread -lg2c"
	fi
	sed -e "s/SHRD_LNK/${libs}/g" -i Make.top || \
		die "Failed to add addtional libs to shared object build"

	cp "${FILESDIR}"/war "${S}"
	chmod a+x "${S}"/war
}

atlas_fail() {
	eerror
	eerror "ATLAS auto-config failed."
	eerror "Please run 'interactive=1 emerge blas-atlas' to configure manually."
	eerror
	die "ATLAS auto-config failed."
}

# Added to allow compilation on sparc architecture. The default CCFLAG0
# and MMFLAGS are *bad*.
# Danny van Dyk <kugelfang@gentoo.org> 2004/07/02
#
reconfigure() {
	case "`uname -p`" in
		"sun4m")
			MY_CCFLAGS="-O3 -mcpu=v8"
			MY_CXXFLAGS="${MY_CCFLAGS}"
			MY_MMFLAGS="-O -mcpu=v8"
			MY_LDFLAGS=""
			;;
		"sun4u")
			MY_CCFLAGS="-O3 -mcpu=ultrasparc"
			MY_CXXFLAGS="${MY_CCFLAGS}"
			MY_MMFLAGS="-O -mcpu=ultrasparc"
			MY_LDFLAGS=""
			;;
		*)
			MY_CCFLAGS="${CFLAGS}"
			MY_CXXFLAGS="${CXXFLAGS}"
			MY_MMFLAGS="${CFLAGS}"
			MY_LDFLAGS="${LDFLAGS}"
			;;
	esac

	MY_FILE="`find -name Make.Linux*`"

	sed -i -e "s/CCFLAG0 =.*/CCFLAG0 = \$(CDEFS) ${MY_CCFLAGS}/" \
		-e "s/CCFLAGS =.*/CCFLAGS = \$(CDEFS) ${MY_CCFLAGS}/" \
		-e "s/CLINKFLAGS =.*/CLINKFLAGS =\$(CDEFS) ${MY_LDFLAGS}/" \
		-e "s/XCCFLAGS =.*/XCCFLAGS =\$(CDEFS) ${MY_CXXFLAGS}/" \
		-e "s/MMFLAGS =.*/MMFLAGS = ${MY_MMFLAGS}/" \
		${MY_FILE} || die "sed didnt complete"
}

src_compile() {
	if [ -n "${interactive}" ]
	then
		echo "${interactive}"
		make config CC="$(tc-getCC) -DUSE_LIBTOOL -DINTERACTIVE" || die
	else
		# Use ATLAS defaults for all questions:
		(echo | make config CC="$(tc-getCC) -DUSE_LIBTOOL") || atlas_fail
	fi

	reconfigure

	TMPSTR=$(ls Make.Linux*)
	ATLAS_ARCH=${TMPSTR#'Make.'}

	make install arch=${ATLAS_ARCH} || \
		die "Failed to install blas-atlas"

	make shared-strip arch=${ATLAS_ARCH} RPATH=${RPATH}/atlas || \
		die "Failed to build shared libraries"

	# Build shared versions of the threaded libs.
	# ATLAS only compiles threaded libs on multiprocessor machines.
	if [ -d gentoo/libptf77blas.a ]
	then
		make ptshared-strip \
			arch=${ATLAS_ARCH} RPATH=${RPATH}/threaded-atlas || die
	fi
}

src_install () {
	dodir "${RPATH}"/atlas
	cd "${S}"/gentoo/libs
	cp -P libatlas* "${D}/${DESTTREE}/$(get_libdir)" || \
		die "Failed to install libatlas"
	cp -P *blas* "${D}/${RPATH}"/atlas || \
		die "Failed to install blas/cblas"

	insinto "${RPATH}"
	doins "${FILESDIR}"/c-ATLAS "${FILESDIR}"/f77-ATLAS

	if [ -d "${S}"/gentoo/threaded-libs ]
	then
		dodir "${RPATH}"/threaded-atlas
		cd "${S}"/gentoo/threaded-libs
		cp -P * "${D}/${RPATH}"/threaded-atlas || \
			die "Failed to install threaded atlas"
		doins "${FILESDIR}"/c-threaded-ATLAS \
				"${FILESDIR}"/f77-threaded-ATLAS
	fi

	insinto "${DESTTREE}"/include/atlas
	doins "${S}"/include/cblas.h "${S}"/include/atlas_misc.h
	doins "${S}"/include/atlas_enum.h

	# These headers contain the architecture-specific
	# optimizations determined by ATLAS. The atlas-lapack build
	# is much shorter if they are available, so save them:
	doins "${S}/include/${ATLAS_ARCH}"/*.h

	#some docs
	cd "${S}"
	dodoc README doc/{AtlasCredits.txt,ChangeLog}
	use doc && dodoc doc/*.ps
}

pkg_postinst() {
	if [ -d "${RPATH}"/threaded-atlas ]
	then
		${DESTTREE}/bin/blas-config threaded-ATLAS
	else
		${DESTTREE}/bin/blas-config ATLAS
	fi

	einfo
	einfo "Fortran users link using -lblas"
	einfo
	einfo "C users compile against the header /usr/include/atlas/cblas.h and"
	einfo "link using -lcblas"
	einfo
}
