# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/oto/oto-0.4.ebuild,v 1.1.1.1 2005/11/30 10:01:24 chriswhite Exp $

DESCRIPTION="Open Type Organizer"
HOMEPAGE="http://sourceforge.net/projects/oto/"
SRC_URI="mirror://sourceforge/oto/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc sparc"
IUSE=""

DEPEND="virtual/libc"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc AUTHORS ChangeLog INSTALL NEWS README
}
