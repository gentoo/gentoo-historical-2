# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/habak/habak-0.2.1.ebuild,v 1.6 2004/07/03 23:10:58 weeve Exp $

DESCRIPTION="A simple but powerful tool to set desktop wallpaper"
HOMEPAGE="http://lubuska.zapto.org/~hoppke/"
SRC_URI="http://lubuska.zapto.org/~hoppke/yellow_brown/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~alpha ppc ~sparc"
IUSE=""

DEPEND="virtual/x11 virtual/xft media-libs/imlib2"

src_compile() {
	emake || die "make failed"
}

src_install() {
	dobin habak
	dodoc ChangeLog README TODO COPYING ${FILESDIR}/README.en
}
