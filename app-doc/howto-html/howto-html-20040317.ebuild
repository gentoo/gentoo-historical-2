# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/howto-html/howto-html-20040317.ebuild,v 1.3 2004/06/24 21:46:17 agriffis Exp $

DESCRIPTION="The LDP howtos, html format"
HOMEPAGE="http://www.tldp.org/"
SRC_URI="mirror://gentoo/Linux-html-HOWTOs-${PV}.tar.bz2"

LICENSE="GPL-2 LDP"
SLOT="0"
IUSE=""
KEYWORDS="x86 ppc sparc"

S=${WORKDIR}/HOWTO

src_install() {
	dodir /usr/share/doc/howto/html
	dosym /usr/share/doc/howto /usr/share/doc/HOWTO

	cp -R * ${D}/usr/share/doc/howto/html || die
}
