# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Peter Gavin <pete@gentoo.org>

S=${WORKDIR}/AfterStep-${PV}
DESCRIPTION="A window manager based on the NeXTStep interface."
SRC_URI="ftp://ftp.afterstep.org/stable/AfterStep-${PV}.tar.bz2"
HOMEPAGE="http://www.afterstep.org/"

DEPEND="virtual/glibc virtual/x11
	>=media-libs/jpeg-6b
	>=media-libs/libpng-1.0.5
	x11-wm/gnustep-env"

RDEPEND="virtual/glibc virtual/x11
	 >=media-libs/jpeg-6b
	 >=media-libs/libpng-1.0.5
	 >=media-sound/sox-12.17.1
	 x11-wm/gnustep-env"


src_compile() {

	./configure --host=${CHOST}					\
    	            --prefix=/usr					\
		    --libdir=/usr/lib					\
		    --mandir=/usr/share/man				\
		    --infodir=/usr/share/info				\
		    --sysconfdir=/etc/X11				\
		    --with-helpcommand="xterm -e man"			\
		    --disable-availability				\
		    --disable-staticlibs || die
		    
	make || die
}

src_install() {

	make DESTDIR=${D}						\
	     GNUSTEP_LOCAL_ROOT=${D}${GNUSTEP_LOCAL_ROOT}		\
	     install || die
	     
	rm -f ${D}/usr/bin/sessreg

	dodoc COPYRIGHT ChangeLog INSTALL NEW README* TEAM UPGRADE
	cp -a ${S}/TODO ${D}/usr/share/doc/${PF}/
	dodir /usr/share/doc/${PF}/html
	cp -a ${S}/doc/* ${D}/usr/share/doc/${PF}/html
	rm ${D}/usr/share/doc/${PF}/html/Makefile*
}
