# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/figurine/figurine-1.0.5.ebuild,v 1.11 2008/01/26 10:57:10 grobian Exp $

DESCRIPTION="A vector based graphics editor similar to xfig, but simpler"
HOMEPAGE="http://figurine.sourceforge.net/"
SRC_URI="mirror://sourceforge/figurine/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND=">=media-gfx/transfig-3.2"

src_compile() {
	econf || die "econf failed"
	emake || die "make failed"
}

src_install() {
	einstall || die
	dodoc AUTHORS BUGS COPYING ChangeLog INSTALL NEWS README
}
