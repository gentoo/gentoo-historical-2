# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/baekmuk-fonts/baekmuk-fonts-2.0.ebuild,v 1.8 2002/10/24 23:23:45 blizzy Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Korean Baekmuk Font"
SRC_URI="ftp://ftp.nnongae.com/pub/gentoo/${P}.tar.gz"
HOMEPAGE="ftp://ftp.nnongae.com/pub/gentoo"
DEPEND="virtual/x11"

SLOT="0"
LICENSE="BAEKMUK"
KEYWORDS="x86 sparc sparc64"

src_install () {
	dodir /usr/X11R6/lib/X11/fonts/baekmuk
	dodir /usr/X11R6/lib/X11/fonts/baekmuk-ttf
	
	mv ${S}/{*.pcf.gz,fonts.dir,fonts.alias} \
		${D}/usr/X11R6/lib/X11/fonts/baekmuk/
	mv ${S}/ttf/* ${D}/usr/X11R6/lib/X11/fonts/baekmuk-ttf/
	
	dodoc COPYRIGHT COPYRIGHT.ks hconfig.ps
}

pkg_postinst() {
	einfo "You must add the path of Baekmuk fonts in the /etc/X11/XF86Config:"
	einfo ""
	einfo "\tSection \"Files\""
	einfo "\t\tFontPath \"/usr/X11R6/lib/X11/fonts/baekmuk/\""
	einfo ""
	einfo "You should restart your X server after that."
}
