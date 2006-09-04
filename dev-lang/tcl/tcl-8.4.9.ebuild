# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/tcl/tcl-8.4.9.ebuild,v 1.15 2006/09/04 08:51:41 vapier Exp $

inherit eutils multilib

DESCRIPTION="Tool Command Language"
HOMEPAGE="http://dev.scriptics.com/software/tcltk/"
SRC_URI="mirror://sourceforge/tcl/${PN}${PV}-src.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"
IUSE="threads"

DEPEND=""

S=${WORKDIR}/${PN}${PV}

pkg_setup() {
	if use threads ; then
		ewarn ""
		ewarn "PLEASE NOTE: You are compiling ${P} with"
		ewarn "threading enabled."
		ewarn "Threading is not supported by all applications"
		ewarn "that compile against tcl. You use threading at"
		ewarn "your own discretion."
		ewarn ""
		epause 5
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-8.4.6-multilib.patch

	# bug 117744
	sed -i -e "s/relid'/relid/" "${S}"/unix/{configure,tcl.m4} || die

	local d
	for d in */configure ; do
		cd "${S}"/${d%%/*}
		EPATCH_SINGLE_MSG="Patching nls cruft in ${d}" \
		epatch "${FILESDIR}"/tcl-configure-LANG.patch
	done
}

src_compile() {
	local local_config_use=""

	if use threads ; then
		local_config_use="--enable-threads"
	fi

	cd "${S}"/unix
	econf ${local_config_use} || die
	emake CFLAGS="${CFLAGS}" || die
}

src_install() {
	#short version number
	local v1
	v1=${PV%.*}

	cd ${S}/unix
	S= make INSTALL_ROOT=${D} MAN_INSTALL_DIR=${D}/usr/share/man install || die

	# fix the tclConfig.sh to eliminate refs to the build directory
	[[ ${ROOT:0-1} != "/" ]] && ROOT=${ROOT}/
	local mylibdir=$(get_libdir) ; mylibdir=${mylibdir//\/}
	sed -i \
		-e "s,^TCL_BUILD_LIB_SPEC='-L.*/unix,TCL_BUILD_LIB_SPEC='-L${ROOT}usr/${mylibdir}," \
		-e "s,^TCL_SRC_DIR='.*',TCL_SRC_DIR='${ROOT}usr/${mylibdir}/tcl${v1}/include'," \
		-e "s,^TCL_BUILD_STUB_LIB_SPEC='-L.*/unix,TCL_BUILD_STUB_LIB_SPEC='-L${ROOT}usr/${mylibdir}," \
		-e "s,^TCL_BUILD_STUB_LIB_PATH='.*/unix,TCL_BUILD_STUB_LIB_PATH='${ROOT}usr/${mylibdir}," \
		-e "s,^TCL_LIB_FILE='libtcl8.4..TCL_DBGX..so',TCL_LIB_FILE=\"libtcl8.4\$\{TCL_DBGX\}.so\"," \
		-e "s,^TCL_CC_SEARCH_FLAGS='\(.*\)',TCL_CC_SEARCH_FLAGS='\1:/usr/${mylibdir}'," \
		-e "s,^TCL_LD_SEARCH_FLAGS='\(.*\)',TCL_LD_SEARCH_FLAGS='\1:/usr/${mylibdir}'," \
		${D}/usr/${mylibdir}/tclConfig.sh

	# install private headers
	dodir /usr/${mylibdir}/tcl${v1}/include/unix
	install -c -m0644 ${S}/unix/*.h ${D}/usr/${mylibdir}/tcl${v1}/include/unix
	dodir /usr/${mylibdir}/tcl${v1}/include/generic
	install -c -m0644 ${S}/generic/*.h ${D}/usr/${mylibdir}/tcl${v1}/include/generic
	rm -f ${D}/usr/${mylibdir}/tcl${v1}/include/generic/tcl.h
	rm -f ${D}/usr/${mylibdir}/tcl${v1}/include/generic/tclDecls.h
	rm -f ${D}/usr/${mylibdir}/tcl${v1}/include/generic/tclPlatDecls.h

	# install symlink for libraries
	dosym /usr/${mylibdir}/libtcl${v1}.so /usr/${mylibdir}/libtcl.so
	dosym /usr/${mylibdir}/libtclstub${v1}.a /usr/${mylibdir}/libtclstub.a

	ln -sf tclsh${v1} ${D}/usr/bin/tclsh

	cd ${S}
	dodoc README changes license.terms
}

pkg_postinst() {
	ewarn
	ewarn "If you're upgrading from tcl-8.3, you must recompile the other"
	ewarn "packages on your system that link with tcl after the upgrade"
	ewarn "completes.  To perform this action, please run revdep-rebuild"
	ewarn "in package app-portage/gentoolkit."
	ewarn "If you have dev-lang/tk and dev-tcltk/tclx installed you should"
	ewarn "upgrade them before this recompilation, too,"
	ewarn
}
