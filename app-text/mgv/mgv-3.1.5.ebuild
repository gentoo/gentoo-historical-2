# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Desktop Team <desktop@gentoo.org>
# /home/cvsroot/gentoo-x86/skel.build,v 1.2 2001/02/15 18:17:31 achim Exp
# $Header: /var/cvsroot/gentoo-x86/app-text/mgv/mgv-3.1.5.ebuild,v 1.6 2002/04/27 09:28:17 seemant Exp $


S=${WORKDIR}/${P}
DESCRIPTION="Gv is a Motif PostScript viewer loosely based on Ghostview"
SRC_URI="http://www.trends.net/~mu/srcs/${P}.tar.gz"
HOMEPAGE="http://www.trends.net/~mu/mgv.html"

DEPEND=">=app-text/ghostscript-3.33
		x11-libs/openmotif"

SLOT="0"

src_compile() {

	econf || die
	make || die

}

src_install () {

	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeLog NEWS README
	dohtml doc/*.sgml

}
