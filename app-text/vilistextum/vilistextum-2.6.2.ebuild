# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-text/vilistextum/vilistextum-2.6.2.ebuild,v 1.2 2002/07/11 06:30:19 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Vilistextum is a html to ascii converter specifically programmed to get the best out of incorrect html."
SRC_URI="http://www.mysunrise.ch/users/bhaak/vilistextum/${P}.tar.bz2"
HOMEPAGE="http://www.mysunrise.ch/users/bhaak/vilistextum/"
LICENSE="GPL"
SLOT="0"

DEPEND="virtual/glibc"

src_compile() {
	econf --enable-multibyte || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc README README.multibyte README.xhtml CHANGES
}
