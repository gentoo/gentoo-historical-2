# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Stuart Bouyer <stuart@palette.plala.or.jp>
# $Header: /var/cvsroot/gentoo-x86/x11-misc/fluxconf/fluxconf-0.6.ebuild,v 1.1 2002/04/26 11:40:52 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Configuration editor for fluxbox"
SRC_URI="http://devaux.fabien.free.fr/flux/${P}.tar.bz2"
HOMEPAGE="http://devaux.fabien.free.fr/flux/"

DEPEND=">=x11-libs/gtk+-1.2.10"



src_compile() {

	emake || die
}

src_install () {

	dobin fluxconf fluxkeys || die

}
