# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/grabcartoons/grabcartoons-1.11.ebuild,v 1.1.1.1 2005/11/30 10:06:08 chriswhite Exp $

DESCRIPTION="comic-summarizing utility"
HOMEPAGE="http://grabcartoons.sourceforge.net/"
SRC_URI="mirror://sourceforge/grabcartoons/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""

src_install() {
	make PREFIX="${D}"/usr install || die
	dodoc ChangeLog README
}
