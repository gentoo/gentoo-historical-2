# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/simgear/simgear-0.3.3.ebuild,v 1.1 2003/07/13 03:13:41 vapier Exp $

MY_P=SimGear-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Development library for simulation games"
HOMEPAGE="http://www.simgear.org/"
SRC_URI="mirror://simgear/Source/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND=">=media-libs/plib-1.6.0
	dev-db/metakit
	media-libs/glut"

src_compile() {
	econf || die
	make || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc README* NEWS AUTHORS ChangeLog
}
