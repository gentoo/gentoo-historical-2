# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/tuxpaint-stamps/tuxpaint-stamps-20041003.ebuild,v 1.3 2005/09/27 12:48:59 metalgod Exp $

inherit eutils

MY_P="${PN}-2004-10-03"
DESCRIPTION="Set of 'Rubber Stamp' images which can be used within Tux Paint."
HOMEPAGE="http://www.newbreedsoftware.com/tuxpaint/"

DEPEND="media-gfx/tuxpaint"

IUSE=""
SRC_URI="mirror://sourceforge/tuxpaint/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 x86"

src_unpack() {
	unpack ${A}
	cd ${S}

	# Sanitize Makefile
	epatch ${FILESDIR}/${MY_P}-makefile.patch
}

src_compile() {
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	rm docs/COPYING.txt
	dodoc docs/*.txt
}
