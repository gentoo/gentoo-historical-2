# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-lang/tk/tk-8.3.3-r1.ebuild,v 1.1 2002/07/13 22:21:33 seemant Exp $


S=${WORKDIR}/${PN}${PV}
SRC_URI="ftp://ftp.scriptics.com/pub/tcl/tcl8_4/${PN}${PV}.tar.gz"

HOMEPAGE="http://dev.scriptics.com/software/tcltk/"

DESCRIPTION="Tk Widget Set"

DEPEND="virtual/glibc
		virtual/x11
		=dev-lang/tcl-${PV}*"

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86"

# hyper-optimizations untested...
#
src_compile() {

	cd ${S}/unix
	./configure --host=${CHOST} \
				--prefix=/usr \
				--mandir=/usr/share/man \
				--with-tcl=/usr/lib \
				--enable-threads || die
					
	emake CFLAGS="${CFLAGS}" || die
	
}

src_install() {
	
	#short version number
	local v1
	v1=${PV%.*}
	
	cd ${S}/unix
	make INSTALL_ROOT=${D} MAN_INSTALL_DIR=${D}/usr/share/man install || die
	
	# fix the tkConfig.sh to eliminate refs to the build directory
	sed -e "s,^TK_BUILD_LIB_SPEC='-L${S2}/unix,TCL_BUILD_LIB_SPEC='-L/usr/lib," \
	    -e "s,^TK_SRC_DIR='${S2}',TCL_SRC_DIR='/usr/lib/tk${V2}/include'," \
	    -e "s,^TK_BUILD_STUB_LIB_SPEC='-L${S2}/unix,TCL_BUILD_STUB_LIB_SPEC='-L/usr/lib," \
	    -e "s,^TK_BUILD_STUB_LIB_PATH='${S2}/unix,TCL_BUILD_STUB_LIB_PATH='/usr/lib," \
	    ${D}/usr/lib/tkConfig.sh > ${D}/usr/lib/tkConfig.sh.new
	mv ${D}/usr/lib/tkConfig.sh.new ${D}/usr/lib/tkConfig.sh
	
	# install private headers
	dodir /usr/lib/tk${V2}/include/unix
	install -c -m0644 ${S}/unix/*.h ${D}/usr/lib/tk${v1}/include/unix
	dodir /usr/lib/tk${v1}/include/generic
	install -c -m0644 ${S}/generic/*.h ${D}/usr/lib/tk${v1}/include/generic
	rm -f ${D}/usr/lib/tk${v1}/include/generic/tk.h
	rm -f ${D}/usr/lib/tk${v1}/include/generic/tkDecls.h
	rm -f ${D}/usr/lib/tk${v1}/include/generic/tkPlatDecls.h	

	# install symlink for libraries
	#dosym /usr/lib/libtk${v1}.a /usr/lib/libtk.a
	dosym /usr/lib/libtk${v1}.so /usr/lib/libtk.so
	dosym /usr/lib/libtkstub${v1}.a /usr/lib/libtkstub.a
	
	ln -sf wish${v1} ${D}/usr/bin/wish
	
	cd ${S}
	dodoc README changes license.terms

}
