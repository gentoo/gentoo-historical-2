# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/x2x/x2x-1.27.ebuild,v 1.1.1.1 2005/11/30 09:40:35 chriswhite Exp $

inherit eutils

DESCRIPTION="An utility to connect the Mouse and KeyBoard to another X"
HOMEPAGE="http://www.the-labs.com/X11/#x2x"
LICENSE="as-is"
DEPEND="virtual/x11"
SRC_URI="http://ftp.digital.com/pub/Digital/SRC/x2x/${P}.tar.gz
	mirror://gentoo/x2x-1.27-license.patch.gz"
SLOT="0"
KEYWORDS="x86 sparc alpha amd64 ~mips"
IUSE=""

src_unpack() {
	unpack ${A}
	cd ${S}

	# Patch to add LICENSE
	epatch ${DISTDIR}/x2x-1.27-license.patch.gz

	# Man-page is packaged as x2x.1 but needs to be x2x.man for building
	mv x2x.1 x2x.man || die
}

src_compile() {
	xmkmf || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	newman x2x.man x2x.1 || die
	dodoc LICENSE || die
}
