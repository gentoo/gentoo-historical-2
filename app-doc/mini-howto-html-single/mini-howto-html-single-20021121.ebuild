# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/mini-howto-html-single/mini-howto-html-single-20021121.ebuild,v 1.1 2002/11/25 05:28:18 danarmak Exp $

MY_P="Linux-mini-html-single-HOWTOs-${PV}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="The LDP mini-howtos, html-single format."

SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"

HOMEPAGE="http://www.linuxdoc.org"

SLOT="0"
LICENSE="GPL-2 LDP"
KEYWORDS="x86 ppc sparc sparc64"

src_install () {
	
	dodir /usr/share/doc/howto/mini
	dodir /usr/share/doc/howto/mini/html-single
	dosym /usr/share/doc/howto /usr/share/doc/HOWTO
	
	cd ${WORKDIR}
	insinto /usr/share/doc/howto/mini/html-single
	doins *
	
}
