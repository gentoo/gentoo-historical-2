# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Author Bart Verwilst <verwilst@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-libs/pwlib/pwlib-1.2.12-r2.ebuild,v 1.3 2002/03/29 14:19:44 seemant Exp $

S="${WORKDIR}/pwlib"
SRC_URI="http://www.gnomemeeting.org/downloads/latest/sources/${PN}_${PV}.tar.gz"
DESCRIPTION="Libs needed for GnomeMeeting"

DEPEND="virtual/glibc
	>=sys-devel/bison-1.28
	>=sys-devel/flex-2.5.4a"

src_unpack() {

	unpack pwlib_1.2.12.tar.gz
	cd ${S}
	patch -p0 < ${FILESDIR}/${PN}-gentoo.diff

}

src_compile() {

	cd ${S}
	export PWLIBDIR=${S}
	export PWLIB_BUILD="yes"
	make optshared || die

	cd tools/asnparser
	make optshared || die

}

src_install() {

	mkdir -p ${D}/usr/lib
	mkdir -p ${D}/usr/include/ptclib
	mkdir -p ${D}/usr/include/ptlib/unix/ptlib
	mkdir -p ${D}/usr/share/pwlib
	cd ${S}	
	cp -a lib/*so* ${D}/usr/lib
	cp -a include/ptlib.h ${D}/usr/include
	cp -a include/ptlib/*.h ${D}/usr/include/ptlib/
	cp -a include/ptlib/*.inl ${D}/usr/include/ptlib/	
	cp -a include/ptlib/unix/ptlib/*.h ${D}/usr/include/ptlib/unix/ptlib
	cp -a include/ptlib/unix/ptlib/*.inl ${D}/usr/include/ptlib/unix/ptlib
	cp -a include/ptclib/*.h ${D}/usr/include/ptclib/

	cp -a * ${D}/usr/share/pwlib/
	rm -rf ${D}/usr/share/pwlib/make/CVS
	#cp -a tools/* ${D}/usr/share/pwlib/tools/
        rm -rf ${D}/usr/share/pwlib/tools/CVS
	rm -rf ${D}/usr/share/pwlib/tools/asnparser/CVS
	rm -rf ${D}/usr/share/pwlib/src
	rm -rf ${D}/usr/share/pwlib/include/CVS
	rm -rf ${D}/usr/share/pwlib/include/ptlib/unix/CVS
	rm -rf ${D}/usr/share/pwlib/include/ptlib/CVS
	cd ${D}/usr/lib
	ln -sf libpt_linux_x86_r.so.1.2.12 libpt.so

}


#pkg_postinst() {
#
#	cd /usr/share/pwlib
#        ln -sf /usr/lib lib
#        ln -sf /usr/include/pwlib include

#}
