# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/tcl/tcl-8.3.4.ebuild,v 1.11 2004/04/24 19:06:44 port001 Exp $

IUSE="threads"

S=${WORKDIR}/${PN}${PV}
SRC_URI="ftp://ftp.scriptics.com/pub/tcl/tcl8_3/${PN}${PV}.tar.gz"

HOMEPAGE="http://dev.scriptics.com/software/tcltk/"

DESCRIPTION="Tool Command Language"

DEPEND="virtual/glibc"

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86 ppc sparc alpha hppa amd64 ia64"

# hyper-optimizations untested...
#

pkg_setup() {

	if [ "`use threads`" ]
	then
		ewarn ""
		ewarn "PLEASE NOTE: You are compiling ${P} with"
		ewarn "threading enabled."
		ewarn "Threading is not supported by all applications"
		ewarn "that compile against tcl. You use threading at"
		ewarn "your own discretion."
		ewarn ""
		sleep 5
	fi
}

src_compile() {

	local local_config_use=""

	if [ "`use threads`" ]
	then
		local_config_use="--enable-threads"
	fi

	cd ${S}/unix
	./configure --host=${CHOST} \
				--prefix=/usr \
				--mandir=/usr/share/man \
				${local_config_use} \
				|| die

	emake CFLAGS="${CFLAGS}" || die

}

src_install() {

	#short version number
	local v1
	v1=${PV%.*}

	cd ${S}/unix
	make INSTALL_ROOT=${D} MAN_INSTALL_DIR=${D}/usr/share/man install || die

	# fix the tclConfig.sh to eliminate refs to the build directory
	sed -e "s,^TCL_BUILD_LIB_SPEC='-L${S}/unix,TCL_BUILD_LIB_SPEC='-L/usr/lib," \
		-e "s,^TCL_SRC_DIR='${S}',TCL_SRC_DIR='/usr/lib/tcl${v1}/include'," \
		-e "s,^TCL_BUILD_STUB_LIB_SPEC='-L${S}/unix,TCL_BUILD_STUB_LIB_SPEC='-L/usr/lib," \
		-e "s,^TCL_BUILD_STUB_LIB_PATH='${S}/unix,TCL_BUILD_STUB_LIB_PATH='/usr/lib," \
		-e "s,^TCL_LIB_FILE='libtcl8.3..TCL_DBGX..so',TCL_LIB_FILE=\"libtcl8.3\$\{TCL_DBGX\}.so\"," \
		${D}/usr/lib/tclConfig.sh > ${D}/usr/lib/tclConfig.sh.new
	mv ${D}/usr/lib/tclConfig.sh.new ${D}/usr/lib/tclConfig.sh

	# install private headers
	dodir /usr/lib/tcl${v1}/include/unix
	install -c -m0644 ${S}/unix/*.h ${D}/usr/lib/tcl${v1}/include/unix
	dodir /usr/lib/tcl${v1}/include/generic
	install -c -m0644 ${S}/generic/*.h ${D}/usr/lib/tcl${v1}/include/generic
	rm -f ${D}/usr/lib/tcl${v1}/include/generic/tcl.h
	rm -f ${D}/usr/lib/tcl${v1}/include/generic/tclDecls.h
	rm -f ${D}/usr/lib/tcl${v1}/include/generic/tclPlatDecls.h

	# install symlink for libraries
	dosym /usr/lib/libtcl${v1}.so /usr/lib/libtcl.so
	dosym /usr/lib/libtclstub${v1}.a /usr/lib/libtclstub.a

	ln -sf tclsh${v1} ${D}/usr/bin/tclsh

	cd ${S}
	dodoc README changes license.terms

}
