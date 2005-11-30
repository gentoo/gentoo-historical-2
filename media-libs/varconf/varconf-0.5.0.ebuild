# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/varconf/varconf-0.5.0.ebuild,v 1.1.1.1 2005/11/30 10:04:14 chriswhite Exp $

DESCRIPTION="A configuration system designed for the STAGE server."
SRC_URI="ftp://victor.worldforge.org/pub/worldforge/libs/varconf/${P}.tar.bz2"
HOMEPAGE="http://www.worldforge.org/"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86 sparc "
IUSE=""

DEPEND="virtual/libc"

src_install() {
	make DESTDIR="${D}" install || die

	dodoc AUTHORS COPYING ChangeLog NEWS README THANKS TODO
}
