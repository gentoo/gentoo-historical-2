# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author John Stalker <stalker@math.princeton.edu>
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xsnow/xsnow-1.42.ebuild,v 1.1 2002/02/02 20:59:53 agriffis Exp $

S=${WORKDIR}/${P}
DESCRIPTION="snow, reindeer, and santa on the root window"
SRC_URI="http://www.euronet.nl/~rja/Xsnow/${P}.tar.gz"
HOMEPAGE="http://www.euronet.nl/~rja/Xsnow/"

DEPEND="virtual/x11"

src_compile() {
	xmkmf || die
	make depend || die
	emake || die
}

src_install () {
	into /usr
	dobin xsnow || die
	rman -f HTML < xsnow._man > xsnow.1-html && \
		mv -f xsnow.1-html xsnow.1.html && \
		mv -f xsnow._man xsnow.1
	doman xsnow.1
	dodoc xsnow.1.html README
}
