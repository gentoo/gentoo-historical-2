# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/oto/oto-0.4.ebuild,v 1.8 2006/07/11 21:10:24 agriffis Exp $

DESCRIPTION="Open Type Organizer"
HOMEPAGE="http://sourceforge.net/projects/oto/"
SRC_URI="mirror://sourceforge/oto/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ia64 ~ppc sparc ~x86"
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
