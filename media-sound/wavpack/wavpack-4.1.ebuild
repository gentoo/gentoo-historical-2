# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/wavpack/wavpack-4.1.ebuild,v 1.2 2004/09/28 20:24:46 eradicator Exp $

DESCRIPTION="WavPack audio compression tools"
HOMEPAGE="http://www.wavpack.com/"
SRC_URI="http://www.wavpack.com/${P}.tar.bz2"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64 ~sparc"
IUSE=""

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}
	sys-devel/automake"

src_compile() {
	./autogen.sh || die
	econf || die
	emake || die
}

src_install() {
	dobin wavpack wvunpack
	dodoc *.txt
}
