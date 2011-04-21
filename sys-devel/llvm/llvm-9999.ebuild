# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/llvm/llvm-9999.ebuild,v 1.12 2011/04/21 09:24:25 grobian Exp $

EAPI="3"
inherit subversion eutils multilib toolchain-funcs

DESCRIPTION="Low Level Virtual Machine"
HOMEPAGE="http://llvm.org/"
SRC_URI=""
ESVN_REPO_URI="http://llvm.org/svn/llvm-project/llvm/trunk"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE="alltargets debug +libffi llvm-gcc ocaml test udis86"

DEPEND="dev-lang/perl
	>=sys-devel/make-3.79
	>=sys-devel/flex-2.5.4
	>=sys-devel/bison-1.28
	!~sys-devel/bison-1.85
	!~sys-devel/bison-1.875
	|| ( >=sys-devel/gcc-3.0 >=sys-devel/gcc-apple-4.2.1 )
	|| ( >=sys-devel/binutils-2.18 >=sys-devel/binutils-apple-3.2.3 )
	libffi? ( virtual/libffi )
	ocaml? ( dev-lang/ocaml )
	udis86? ( amd64? ( dev-libs/udis86[pic] )
		!amd64? ( dev-libs/udis86 ) )"
RDEPEND="dev-lang/perl"

S=${WORKDIR}/${PN}-${PV/_pre*}

pkg_setup() {
	# need to check if the active compiler is ok

	broken_gcc=" 3.2.2 3.2.3 3.3.2 4.1.1 "
	broken_gcc_x86=" 3.4.0 3.4.2 "
	broken_gcc_amd64=" 3.4.6 "

	gcc_vers=$(gcc-fullversion)

	if [[ ${broken_gcc} == *" ${version} "* ]] ; then
		elog "Your version of gcc is known to miscompile llvm."
		elog "Check http://www.llvm.org/docs/GettingStarted.html for"
		elog "possible solutions."
		die "Your currently active version of gcc is known to miscompile llvm"
	fi

	if [[ ${CHOST} == i*86-* && ${broken_gcc_x86} == *" ${version} "* ]] ; then
		elog "Your version of gcc is known to miscompile llvm on x86"
		elog "architectures.  Check"
		elog "http://www.llvm.org/docs/GettingStarted.html for possible"
		elog "solutions."
		die "Your currently active version of gcc is known to miscompile llvm"
	fi

	if [[ ${CHOST} == x86_64-* && ${broken_gcc_amd64} == *" ${version} "* ]];
	then
		 elog "Your version of gcc is known to miscompile llvm in amd64"
		 elog "architectures.  Check"
		 elog "http://www.llvm.org/docs/GettingStarted.html for possible"
		 elog "solutions."
		die "Your currently active version of gcc is known to miscompile llvm"
	 fi
}

src_prepare() {
	# unfortunately ./configure won't listen to --mandir and the-like, so take
	# care of this.
	einfo "Fixing install dirs"
	sed -e 's,^PROJ_docsdir.*,PROJ_docsdir := $(PROJ_prefix)/share/doc/'${PF}, \
		-e 's,^PROJ_etcdir.*,PROJ_etcdir := '"${EPREFIX}"'/etc/llvm,' \
		-e 's,^PROJ_libdir.*,PROJ_libdir := $(PROJ_prefix)/'$(get_libdir)/${PN}, \
		-i Makefile.config.in || die "Makefile.config sed failed"
	sed -e 's,$ABS_RUN_DIR/lib,'"${EPREFIX}"/usr/$(get_libdir)/${PN}, \
		-i tools/llvm-config/llvm-config.in.in || die "llvm-config sed failed"

	einfo "Fixing rpath"
	sed -e 's,\$(RPATH) -Wl\,\$(\(ToolDir\|LibDir\)),$(RPATH) -Wl\,'"${EPREFIX}"/usr/$(get_libdir)/${PN}, \
		-i Makefile.rules || die "rpath sed failed"

	epatch "${FILESDIR}"/${PN}-2.9-nodoctargz.patch
	epatch "${FILESDIR}"/${PN}-2.6-commandguide-nops.patch
}

src_configure() {
	local CONF_FLAGS="--enable-shared"

	if use debug; then
		CONF_FLAGS="${CONF_FLAGS} --disable-optimized"
		einfo "Note: Compiling LLVM in debug mode will create huge and slow binaries"
		# ...and you probably shouldn't use tmpfs, unless it can hold 900MB
	else
		CONF_FLAGS="${CONF_FLAGS} \
			--enable-optimized \
			--disable-assertions \
			--disable-expensive-checks"
	fi

	if use alltargets; then
		CONF_FLAGS="${CONF_FLAGS} --enable-targets=all"
	else
		CONF_FLAGS="${CONF_FLAGS} --enable-targets=host-only"
	fi

	if use amd64; then
		CONF_FLAGS="${CONF_FLAGS} --enable-pic"
	fi

	# things would be built differently depending on whether llvm-gcc is
	# used or not.
	local LLVM_GCC_DIR=/dev/null
	local LLVM_GCC_DRIVER=nope ; local LLVM_GPP_DRIVER=nope
	if use llvm-gcc ; then
		if has_version sys-devel/llvm-gcc; then
			LLVM_GCC_DIR=$(ls -d ${EROOT}/usr/$(get_libdir)/llvm-gcc* 2> /dev/null)
			LLVM_GCC_DRIVER=$(find ${LLVM_GCC_DIR} -name 'llvm*-gcc' 2> /dev/null)
			if [[ -z ${LLVM_GCC_DRIVER} ]] ; then
				die "failed to find installed llvm-gcc, LLVM_GCC_DIR=${LLVM_GCC_DIR}"
			fi
			einfo "Using $LLVM_GCC_DRIVER"
			LLVM_GPP_DRIVER=${LLVM_GCC_DRIVER/%-gcc/-g++}
		else
			eerror "llvm-gcc USE flag enabled, but sys-devel/llvm-gcc was not found"
			eerror "Building with standard gcc, re-merge this package after installing"
			eerror "llvm-gcc to build with it"
			eerror "This is normal behavior on first LLVM merge"
		fi
	fi

	CONF_FLAGS="${CONF_FLAGS} \
		--with-llvmgccdir=${LLVM_GCC_DIR} \
		--with-llvmgcc=${LLVM_GCC_DRIVER} \
		--with-llvmgxx=${LLVM_GPP_DRIVER}"

	if use ocaml; then
		CONF_FLAGS="${CONF_FLAGS} --enable-bindings=ocaml"
	else
		CONF_FLAGS="${CONF_FLAGS} --enable-bindings=none"
	fi

	if use udis86; then
		CONF_FLAGS="${CONF_FLAGS} --with-udis86"
	fi
	CONF_FLAGS="${CONF_FLAGS} $(use_enable libffi)"
	econf ${CONF_FLAGS} || die "econf failed"
}

src_compile() {
	emake VERBOSE=1 KEEP_SYMBOLS=1 REQUIRES_RTTI=1 || die "emake failed"
}

src_install() {
	emake KEEP_SYMBOLS=1 DESTDIR="${D}" install || die "install failed"

	# Fix install_names on Darwin.  The build system is too complicated
	# to just fix this, so we correct it post-install
	if [[ ${CHOST} == *-darwin* ]] ; then
		for lib in lib{EnhancedDisassembly,LLVM-${PV},LTO}.dylib {BugpointPasses,LLVMHello,profile_rt}.dylib ; do
			# libEnhancedDisassembly is Darwin10 only, so non-fatal
			[[ -f ${ED}/usr/lib/${PN}/${lib} ]] || continue
			ebegin "fixing install_name of $lib"
			install_name_tool \
				-id "${EPREFIX}"/usr/lib/${PN}/${lib} \
				"${ED}"/usr/lib/${PN}/${lib}
			eend $?
		done
		for f in "${ED}"/usr/bin/* "${ED}"/usr/lib/${PN}/libLTO.dylib ; do
			ebegin "fixing install_name reference to libLLVM-${PV}.dylib of ${f##*/}"
			install_name_tool \
				-change "@executable_path/../lib/libLLVM-${PV}.dylib" \
					"${EPREFIX}"/usr/lib/${PN}/libLLVM-${PV}.dylib \
				"${f}"
			eend $?
		done
	fi
}
