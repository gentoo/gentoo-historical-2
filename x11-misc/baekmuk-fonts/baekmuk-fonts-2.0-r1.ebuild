# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Jays Kwak <jayskwak@gentoo.or.kr>
# $Header: /var/cvsroot/gentoo-x86/x11-misc/baekmuk-fonts/baekmuk-fonts-2.0-r1.ebuild,v 1.1 2002/07/11 02:18:43 jayskwak Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Korean Baekmuk Font"
SRC_URI="ftp://ftp.nnongae.com/pub/gentoo/${P}.tar.gz"
HOMEPAGE="http://"
DEPEND="virtual/x11"
LICENSE="BAEKMUK"
SLOT="0"
KEYWORDS="x86"

src_unpack () {
	unpack ${P}.tar.gz
}

src_install () {
	dodir /usr/X11R6/lib/X11/fonts/baekmuk
	dodir /usr/share/fonts/ttf/korean/baekmuk
	
	mv ${S}/{*.pcf.gz,fonts.dir,fonts.alias} \
		${D}/usr/X11R6/lib/X11/fonts/baekmuk/
	mv ${S}/ttf/* ${D}/usr/share/fonts/ttf/korean/baekmuk/
	
	dodoc COPYRIGHT COPYRIGHT.ks hconfig.ps
}

pkg_postinst() {
	einfo "You HAVE TO add the path of Backmuk fonts in the /etc/X11/XF86Config"

	ewarn "****************************************************************"
	ewarn "* Section \"Files\"                                              *"
	ewarn "*       FontPath \"/usr/X11R6/lib/X11/fonts/baekmuk/\"           *"
	ewarn "****************************************************************"

	einfo "You should restart X server..."
															
}
