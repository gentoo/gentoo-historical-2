# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# /space/gentoo/cvsroot/gentoo-x86/dev-lang/tcl-tk/tcl-tk-8.4.2.ebuild,v 1.7 2001/11/10 11:31:53 hallski Exp


S=${WORKDIR}/${PN}${PV}
SRC_URI="ftp://ftp.scriptics.com/pub/tcl/tcl8_4/${PN}${PV}.tar.gz"


HOMEPAGE="http://dev.scriptics.com/software/tcltk/"

DESCRIPTION="Tool Command Language"

DEPEND="virtual/glibc"

# hyper-optimizations untested...
#

src_compile() {

	cd ${S}/unix
	./configure --host=${CHOST} \
				--prefix=/usr \
				--mandir=/usr/share/man \
				--enable-threads || die
				
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
	dosym /usr/lib/libtcl${v1}.a /usr/lib/libtcl.a
	dosym /usr/lib/libtclstub${v1}.a /usr/lib/libtclstub.a
	
	ln -sf tclsh${v1} ${D}/usr/bin/tclsh
	
	cd ${S}
	dodoc README changes license.terms

}
