# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/afterstep/afterstep-1.8.11-r2.ebuild,v 1.13 2003/06/12 18:59:59 msterret Exp $

S=${WORKDIR}/AfterStep-${PV}
DESCRIPTION="A window manager based on the NeXTStep interface."
SRC_URI="ftp://ftp.afterstep.org/stable/AfterStep-${PV}.tar.bz2"
HOMEPAGE="http://www.afterstep.org/"
LICENSE="AFTERSTEP"
SLOT="0"
KEYWORDS="x86 sparc ~ppc"
IUSE="nls"

DEPEND="virtual/glibc virtual/x11
	>=media-libs/jpeg-6b
	>=media-libs/libpng-1.2.1
	x11-wm/gnustep-env"
## >=media-libs/xpm-3.4k

RDEPEND="${DEPEND}
	 >=media-sound/sox-12.17.1"


src_unpack() {
	unpack ${A}
	cd ${S}
	patch -p0 < ${FILESDIR}/${P}-gentoo.diff
}

src_compile() {
	local myconf
	use nls && myconf="${myconf} --enable-i18n"

	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--libdir=/usr/lib \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--sysconfdir=/etc/X11 \
		--with-helpcommand="xterm -e man" \
		--disable-availability \
		--disable-staticlibs \
		--with-xpm \
		${myconf} || die
		    
	emake || die
}

src_install() {

	make DESTDIR=${D} \
	     GNUSTEP_LOCAL_ROOT=${D}${GNUSTEP_LOCAL_ROOT} \
	     install || die
	     
	rm -f ${D}/usr/bin/sessreg

	dodoc COPYRIGHT ChangeLog INSTALL NEW README* TEAM UPGRADE
	cp -a ${S}/TODO ${D}/usr/share/doc/${PF}/
	dodir /usr/share/doc/${PF}/html
	cp -a ${S}/doc/* ${D}/usr/share/doc/${PF}/html
	rm ${D}/usr/share/doc/${PF}/html/Makefile*
	
	exeinto /etc/X11/Sessions
	doexe ${FILESDIR}/afterstep
	
}
