# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/cdplay/cdplay-0.9.ebuild,v 1.6 2004/07/01 07:49:32 eradicator Exp $

DESCRIPTION="Console CD Player"
HOMEPAGE="http://www.x-paste.de/projects/index.php"
SRC_URI="http://www.x-paste.de/files/${P}.tar.gz"

DEPEND="virtual/libc"
IUSE=""
SLOT="0"
LICENSE="GPL-2"

KEYWORDS="x86 ~ppc ~alpha"

src_compile() {
	make || die
}

src_install() {
	dobin cdplay
	dodoc CREDITS README
}
