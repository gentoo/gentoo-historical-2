# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/fbdesk/fbdesk-1.1.2.ebuild,v 1.4 2003/10/13 15:46:03 tseng Exp $

IUSE=""

S=${WORKDIR}/${P}

DESCRIPTION="FbDesk is a fluxbox-util application that creates and manage icons on your Fluxbox desktop."
HOMEPAGE="http://www.fluxbox.org/fbdesk/"
SRC_URI="http://www.fluxbox.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~ia64"

DEPEND="media-libs/libpng
	virtual/x11"

src_compile() {
	econf || die
	emake || die
}

src_install () {
	einstall || die

	dodoc AUTHORS COPYING ChangeLog NEWS README
}
