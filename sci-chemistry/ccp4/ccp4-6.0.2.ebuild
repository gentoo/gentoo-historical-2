# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/ccp4/ccp4-6.0.2.ebuild,v 1.9 2010/12/16 13:09:16 jlec Exp $

inherit eutils gnuconfig toolchain-funcs

SRC="ftp://ftp.ccp4.ac.uk/ccp4"

PATCH_TOT="0"
#PATCH1=( src/mmdb_app_
#	chainsaw.cpp-11May2006.diff )
#PATCH2=( src
#	anisoanl.f-r1.22-r1.24.diff )

DESCRIPTION="Protein X-ray crystallography toolkit"
HOMEPAGE="http://www.ccp4.ac.uk/"
RESTRICT="mirror"
SRC_URI="${SRC}/${PV}/source/${P}-core-src.tar.gz"
for i in $(seq $PATCH_TOT); do
	NAME="PATCH${i}[1]"
	SRC_URI="${SRC_URI}
		${SRC}/${PV}/patches/${!NAME}"
done

LICENSE="ccp4"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE="X"

# app-office/sc overlaps sc binary and man page
# We can't rename ours since the automated ccp4i interface expects it there,
# as do many scripts. app-office/sc can't rename its because that's the name
# of the package.
RDEPEND="
		>=dev-lang/tcl-8.3
		>=dev-lang/tk-8.3
		>=dev-tcltk/blt-2.4
		virtual/lapack
		virtual/blas
		=sci-libs/fftw-2*
		sci-chemistry/pdb-extract
		sci-chemistry/rasmol
		sci-libs/mccp4
		app-shells/tcsh
		!app-office/sc
		X? (
			x11-libs/libX11
			x11-libs/libXt
			x11-libs/libXaw
		)"
DEPEND="${RDEPEND}
		X? (
			x11-misc/imake
			x11-proto/inputproto
			x11-proto/xextproto
		)"

S="${WORKDIR}/${PN}-${PV}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	einfo "Applying upstream patches ..."
	for patch in $(seq $PATCH_TOT); do
		base="PATCH${patch}"
		dir=$(eval echo \${${base}[0]})
		p=$(eval echo \${${base}[1]})
		pushd ${dir} >& /dev/null
		ccp_patch "${DISTDIR}/${p}"
		popd >& /dev/null
	done
	einfo "Done."
	echo

	einfo "Applying Gentoo patches ..."
	# These two only needed when attempting to install outside build dir via
	# --bindir and --libdir instead of straight copying after build

	# it attempts to install some libraries during the build
	#ccp_patch "${FILESDIR}"/${P}-install-libs-at-install-time.patch
	# hklview/ipdisp.exe/xdlmapman/ipmosflm can't find libxdl_view
	# without this patch when --libdir is set
	# Rotgen still needs more patching to find it
	#ccp_patch "${FILESDIR}"/add-xdl-libdir.patch

	# it tries to create libdir, bindir etc on live system in configure
	ccp_patch "${FILESDIR}"/${PV}-dont-make-dirs-in-configure.patch

	# We already have sci-chemistry/rasmol
	ccp_patch "${FILESDIR}"/dont-build-rasmol.patch

	# We already have sci-chemistry/pdb-extract
# Use configure option instead
#	ccp_patch "${FILESDIR}"/dont-build-pdb-extract.patch

	ccp_patch "${FILESDIR}"/create-mosflm-bindir.patch
	ccp_patch "${FILESDIR}"/make-mosflm-libdir.patch
	ccp_patch "${FILESDIR}"/make-mosflm-index-libdir.patch
	ccp_patch "${FILESDIR}"/make-mosflm-cbf-libdir.patch
	ccp_patch "${FILESDIR}"/make-ipmosflm-dir.patch

# Don't use these when we aren't building phaser
#	ccp_patch "${FILESDIR}"/make-phaser-bindir.patch
#	ccp_patch "${FILESDIR}"/no-phaser-ld-assume-kernel.patch
#	# scons config.py tries to chmod python on live system
#	ccp_patch "${FILESDIR}"/dont-chmod-python-binary.patch

	# Don't use this when we aren't building clipper
	# For some reason clipper check for $enableval even when --enable is passed
	ccp_patch "${FILESDIR}"/pass-clipper-enablevals.patch
	ccp_patch "${FILESDIR}"/clipper-find-mccp4-includes.patch

	# Default to firefox browser, not 'netscape'
	ccp_patch "${FILESDIR}"/ccp4i-default-to-firefox.patch

	# Also use -lpthread when linking blas and lapack
	# We may need more fixing to use libcblas for the C files
	ccp_patch "${FILESDIR}"/check-blas-lapack-pthread.patch

	# gerror_ gets defined twice on ppc if you're using gfortran/g95
	ccp_patch "${FILESDIR}"/${PV}-ppc-double-define-gerror.patch

	einfo "Done." # done applying Gentoo patches
	echo

	gnuconfig_update
}

src_compile() {
	# Build system is broken if we set LDFLAGS
	unset LDFLAGS

	# GENTOO_OSNAME can be one of:
	# irix irix64 sunos sunos64 aix hpux osf1 linux freebsd
	# linux_compaq_compilers linux_intel_compilers generic Darwin
	# ia64_linux_intel Darwin_ibm_compilers linux_ibm_compilers
	if [[ "$(tc-getFC)" = "ifort" ]]; then
		if use ia64; then
			GENTOO_OSNAME="ia64_linux_intel"
		else
			# Should be valid for x86, maybe amd64
			GENTOO_OSNAME="linux_intel_compilers"
		fi
	else
		# Should be valid for x86 and amd64, at least
		GENTOO_OSNAME="linux"
	fi

	# Sets up env
	ln -s \
		ccp4.setup-bash \
		"${S}"/include/ccp4.setup

	# We agree to the license by emerging this, set in LICENSE
	sed -i \
		-e "s~^\(^agreed=\).*~\1yes~g" \
		"${S}"/configure

	# Fix up variables -- need to reset CCP4_MASTER at install-time
	sed -i \
		-e "s~^\(setenv CCP4_MASTER.*\)/.*~\1${WORKDIR}~g" \
		-e "s~^\(setenv CCP4I_TCLTK.*\)/usr/local/bin~\1/usr/bin~g" \
		"${S}"/include/ccp4.setup*

	# Set up variables for build
	source "${S}"/include/ccp4.setup

	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export COPTIM=${CFLAGS}
	export CXXOPTIM=${CXXFLAGS}
	# Default to -O2 if FFLAGS is unset
	export FC=$(tc-getFC)
	export FOPTIM=${FFLAGS:- -O2}

	# Can't use econf, configure rejects unknown options like --prefix
	./configure \
		$(use_enable X x) \
		--with-shared-libs \
		--with-fftw=/usr \
		--with-warnings \
		--disable-pdb_extract \
		--disable-cctbx \
		--disable-phaser \
		--tmpdir="${TMPDIR}" \
		${GENTOO_OSNAME} || die "econf failed"
	emake -j1 || die "emake failed"
}

src_install() {
	# Set up variables for build
	source "${S}"/include/ccp4.setup

# Only needed when using --bindir and --libdir
	# Needed to avoid errors. Originally tried to make lib and bin
	# in configure script, now patched out by dont-make-dirs-in-configure.patch
#	dodir /usr/include /usr/$(get_libdir) /usr/bin

#	make install || die "install failed"
	einstall || die "install failed"

	# Fix env
	sed -i \
		-e "s~^\(setenv CCP4_MASTER.*\)${WORKDIR}~\1/usr~g" \
		-e "s~^\(setenv CCP4.*\$CCP4_MASTER\).*~\1~g" \
		-e "s~^\(setenv CCP4I_TOP\).*~\1 \$CCP4/$(get_libdir)/ccp4/ccp4i~g" \
		-e "s~^\(.*setenv CINCL.*\$CCP4\).*~\1/share/ccp4/include~g" \
		-e "s~^\(.*setenv CLIBD .*\$CCP4\).*~\1/share/ccp4/data~g" \
		-e "s~^\(.*setenv CLIBD_MON .*\)\$CCP4.*~\1\$CLIBD/monomers/~g" \
		-e "s~^\(.*setenv MOLREPLIB .*\)\$CCP4.*~\1\$CLIBD/monomers/~g" \
		-e "s~^\(.*setenv CCP4_BROWSER.*\).*~\1 firefox~g" \
		"${S}"/include/ccp4.setup*

	# Get rid of S instances
	# Also the main clipper library is built as libclipper-core, not libclipper
	sed -i \
		-e "s:${S}:$usr:g" \
		-e "s:lclipper :lclipper-core :g" \
		"${S}"/bin/clipper-config
#	sed -i \
#		-e "s:${S}:usr:g" \
#		"${S}"/$(get_libdir)/cctbx/cctbx_build/setpaths*

	# Bins
	dobin "${S}"/bin/* || die

	# Libs
	for file in "${S}"/lib/*; do
		if [[ -d ${file} ]]; then
			continue
		elif [[ -x ${file} ]]; then
			dolib.so ${file} || die
		else
			insinto /usr/$(get_libdir)
			doins ${file} || die
		fi
	done

	# Fix libdir in all *.la files
	sed -i \
		-e "s:^\(libdir=\).*:\1\'/usr/$(get_libdir)\':g" \
		"${D}"/usr/$(get_libdir)/*.la

	# Library symlinks
	local LIBNAMES="libclipper-ccp4.so.0.0.0
		libclipper-cif.so.0.0.0
		libclipper-contrib.so.0.0.0
		libclipper-core.so.0.0.0
		libclipper-minimol.so.0.0.0
		libclipper-mmdbold.so.0.0.0
		libclipper-mmdb.so.0.0.0
		libclipper-mtz.so.1.0.0
		libclipper-phs.so.0.0.0
		libjwc_c.so.0.1.1
		libjwc_f.so.0.1.1
		libssm.so.0.0.0
		libxdl_viewextra.so.0.0.0
		libxdl_view.so.2.0.0"

	for LIBNAME in ${LIBNAMES}; do
		library_dosym ${LIBNAME}
	done

#	dosym libclipper-ccp4.so.0.0.0 /usr/$(get_libdir)/libclipper-ccp4.so
#	dosym libclipper-ccp4.so.0.0.0 /usr/$(get_libdir)/libclipper-ccp4.so.0
#	dosym libclipper-ccp4.so.0.0.0 /usr/$(get_libdir)/libclipper-ccp4.so.0.0
#
#	dosym libclipper-cif.so.0.0.0 /usr/$(get_libdir)/libclipper-cif.so
#	dosym libclipper-cif.so.0.0.0 /usr/$(get_libdir)/libclipper-cif.so.0
#	dosym libclipper-cif.so.0.0.0 /usr/$(get_libdir)/libclipper-cif.so.0.0
#
#	dosym libclipper-contrib.so.0.0.0 /usr/$(get_libdir)/libclipper-contrib.so
#	dosym libclipper-contrib.so.0.0.0 /usr/$(get_libdir)/libclipper-contrib.so.0
#	dosym libclipper-contrib.so.0.0.0 /usr/$(get_libdir)/libclipper-contrib.so.0.0
#
#	dosym libclipper-core.so.0.0.0 /usr/$(get_libdir)/libclipper-core.so
#	dosym libclipper-core.so.0.0.0 /usr/$(get_libdir)/libclipper-core.so.0
#	dosym libclipper-core.so.0.0.0 /usr/$(get_libdir)/libclipper-core.so.0.0
#
#	dosym libclipper-minimol.so.0.0.0 /usr/$(get_libdir)/libclipper-minimol.so
#	dosym libclipper-minimol.so.0.0.0 /usr/$(get_libdir)/libclipper-minimol.so.0
#	dosym libclipper-minimol.so.0.0.0 /usr/$(get_libdir)/libclipper-minimol.so.0.0
#
#	dosym libclipper-mmdbold.so.0.0.0 /usr/$(get_libdir)/libclipper-mmdbold.so
#	dosym libclipper-mmdbold.so.0.0.0 /usr/$(get_libdir)/libclipper-mmdbold.so.0
#	dosym libclipper-mmdbold.so.0.0.0 /usr/$(get_libdir)/libclipper-mmdbold.so.0.0
#
#	dosym libclipper-mmdb.so.0.0.0 /usr/$(get_libdir)/libclipper-mmdb.so
#	dosym libclipper-mmdb.so.0.0.0 /usr/$(get_libdir)/libclipper-mmdb.so.0
#	dosym libclipper-mmdb.so.0.0.0 /usr/$(get_libdir)/libclipper-mmdb.so.0.0
#
#	dosym libclipper-mtz.so.1.0.0 /usr/$(get_libdir)/libclipper-mtz.so
#	dosym libclipper-mtz.so.1.0.0 /usr/$(get_libdir)/libclipper-mtz.so.1
#	dosym libclipper-mtz.so.1.0.0 /usr/$(get_libdir)/libclipper-mtz.so.1.0
#
#	dosym libclipper-phs.so.0.0.0 /usr/$(get_libdir)/libclipper-phs.so
#	dosym libclipper-phs.so.0.0.0 /usr/$(get_libdir)/libclipper-phs.so.0
#	dosym libclipper-phs.so.0.0.0 /usr/$(get_libdir)/libclipper-phs.so.0.0
#
#	dosym libjwc_c.so.0.1.1 /usr/$(get_libdir)/libjwc_c.so
#	dosym libjwc_c.so.0.1.1 /usr/$(get_libdir)/libjwc_c.so.0
#	dosym libjwc_c.so.0.1.1 /usr/$(get_libdir)/libjwc_c.so.0.1
#
#	dosym libjwc_f.so.0.1.1 /usr/$(get_libdir)/libjwc_f.so
#	dosym libjwc_f.so.0.1.1 /usr/$(get_libdir)/libjwc_f.so.0
#	dosym libjwc_f.so.0.1.1 /usr/$(get_libdir)/libjwc_f.so.0.1
#
#	dosym libssm.so.0.0.0 /usr/$(get_libdir)/libssm.so
#	dosym libssm.so.0.0.0 /usr/$(get_libdir)/libssm.so.0
#	dosym libssm.so.0.0.0 /usr/$(get_libdir)/libssm.so.0.0
#
#	dosym libxdl_viewextra.so.0.0.0 /usr/$(get_libdir)/libxdl_viewextra.so
#	dosym libxdl_viewextra.so.0.0.0 /usr/$(get_libdir)/libxdl_viewextra.so.0
#	dosym libxdl_viewextra.so.0.0.0 /usr/$(get_libdir)/libxdl_viewextra.so.0.0
#
#	dosym libxdl_view.so.2.0.0 /usr/$(get_libdir)/libxdl_view.so
#	dosym libxdl_view.so.2.0.0 /usr/$(get_libdir)/libxdl_view.so.2
#	dosym libxdl_view.so.2.0.0 /usr/$(get_libdir)/libxdl_view.so.2.0

	# Environment files, setup scripts, etc.
	insinto /usr/share/ccp4/include
	doins "${S}"/include/* || die

	# CCP4Interface - GUI
	insinto /usr/$(get_libdir)/ccp4
	doins -r "${S}"/ccp4i || die
	exeinto /usr/$(get_libdir)/ccp4/ccp4i/bin
	doexe "${S}"/ccp4i/bin/* || die

	# Data
	insinto /usr/share/ccp4
	doins -r "${S}"/lib/data || die

	# Include files
	insinto /usr/include
	for i in ccp4 clipper mmdb ssm; do
		doins -r "${S}"/include/${i} || die
	done

	# Install docs and examples

	doman "${S}"/man/cat1/*

	mv "${S}"/manual/README "${S}"/manual/README-manual
	dodoc "${S}"/manual/*

	dodoc "${S}"/README "${S}"/CHANGES

	dodoc "${S}"/doc/*
	rm "${D}"/usr/share/doc/${PF}/GNUmakefile.gz
	rm "${D}"/usr/share/doc/${PF}/COPYING.gz

	dohtml -r "${S}"/html/*
	dodoc "${S}"/examples/README

	# Fix wrongly installed HTML pages from clipper
	dohtml "${D}"/usr/html/*
	rm -rf "${D}"/usr/html

	for i in data rnase toxd; do
		docinto examples/${i}
		dodoc "${S}"/examples/${i}/*
	done

	docinto examples/tutorial
	dohtml -r "${S}"/examples/tutorial/html examples/tutorial/tut.css
	for i in data results; do
		docinto examples/tutorial/${i}
		dodoc "${S}"/examples/tutorial/${i}/*
	done

	for i in non-runnable runnable; do
		docinto examples/unix/${i}
		dodoc "${S}"/examples/unix/${i}
	done

	# Needed for ccp4i docs to work
	dosym ../../share/doc/${PF}/examples /usr/$(get_libdir)/ccp4/examples
	dosym ../../share/doc/${PF}/html /usr/$(get_libdir)/ccp4/html

	# Fix overlaps with other packages
	rm "${D}"/usr/share/man/man1/rasmol.1*
}

pkg_postinst() {
	einfo "The Web browser defaults to firefox. Change CCP4_BROWSER"
	einfo "in /usr/share/ccp4/include/ccp4.setup* to modify this."

	ewarn "Set your .bashrc or other shell login file to source"
	ewarn "one of the ccp4.setup* files in ${ROOT}usr/share/ccp4/include."
	ewarn "CCP4 will not work without this."
}

# Epatch wrapper for bulk patching
ccp_patch() {
	EPATCH_SINGLE_MSG="  ${1##*/} ..." epatch ${1}
}

# Links libname.so, libname.so.major and libname.so.major.minor
# to libname.so.major.minor.micro
library_dosym() {
	local LIBNAME LIBDIR SUFFIX CORE_LIBNAME LIB_MAJOR LIB_MINOR LIB_VERSIONS

	LIBNAME=${1}
	LIBDIR=${2:-/usr/$(get_libdir)}

	# Tag / on the end of libdir if needed
	if [[ ${LIBDIR:$((${#LIBDIR}-1)):1} != "/" ]]; then
		LIBDIR="${LIBDIR}/"
	fi

	if [[ "${LIBNAME}" != *.so.* ]]; then
		msg="library_dosym() requires a shared, versioned library as an argument"
		eerror "$msg"
		die "$msg"
	fi

	SUFFIX=${LIBNAME##*so.}
	CORE_LIBNAME=${LIBNAME%.so.*}
	CORE_LIBNAME="${CORE_LIBNAME}.so"
	LIB_MAJOR=${SUFFIX%%.*}
	LIB_MINOR=${SUFFIX#*.}
	LIB_MINOR=${SUFFIX%%.*}
	LIB_VERSIONS="${LIB_MAJOR} ${LIB_MAJOR}.${LIB_MINOR}"
	for LIB_SUFFIX in .${LIB_MAJOR} .${LIB_MAJOR}.${LIB_MINOR} ""; do
		einfo "Calling dosym ${LIBNAME} ${LIBDIR} ${CORE_LIBNAME} ${LIB_SUFFIX}"
		dosym ${LIBNAME} ${LIBDIR}${CORE_LIBNAME}${LIB_SUFFIX}
	done
}
