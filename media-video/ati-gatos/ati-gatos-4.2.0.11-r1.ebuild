# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ati-gatos/ati-gatos-4.2.0.11-r1.ebuild,v 1.9 2003/11/18 17:23:32 mholzer Exp $

S=${WORKDIR}/X11R6
MY_P=ATI-4.2.0-11
DESCRIPTION="ATI drivers for Xfree86 that support ATI video capabilities"
SRC_URI="mirror://sourceforge/gatos/${MY_P}.i386.tar.gz"
RESTRICT="nomirror"
HOMEPAGE="http://gatos.sourceforge.net"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 -ppc"

DEPEND="x11-base/xfree"

src_install () {
	dodoc ${S}/README* ${S}/ATI*
	cd ${S}/lib/modules
	insinto /usr/X11R6/lib/modules/multimedia
	doins multimedia/*.o

	cd ${S}/lib/modules/drivers
	insinto /usr/X11R6/lib/modules/drivers
	for x in *.o
	do
		newins ${x} gatos-${x}
	done
}

pkg_postinst() {
	einfo "To ensure that the drivers distributed with XFree86 do not"
	einfo "get over written with the ones distributed with this package,"
	einfo "\"gatos-\" is pre-pended to all the drivers.  This means that"
	einfo "for instance, \"ati_drv.o\" have become \"gatos-ati_drv.o\","
	einfo "and that \"gatos-ati\" should be used in your XF86Config."
}
