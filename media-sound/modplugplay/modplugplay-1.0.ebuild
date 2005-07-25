# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/modplugplay/modplugplay-1.0.ebuild,v 1.3 2005/07/25 13:20:52 dholm Exp $

IUSE=""

inherit toolchain-funcs

DESCRIPTION="A commandline player for mod music"
HOMEPAGE="http://www.linuks.mine.nu/modplugplay/"
SRC_URI="http://www.linuks.mine.nu/modplugplay/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
#-sparc: 1.0 - Bus Error on play
KEYWORDS="amd64 ~ppc -sparc x86"

RDEPEND=">=media-libs/libmodplug-0.7"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	$(tc-getCC) -o modplugplay modplugplay.c $(pkg-config libmodplug --cflags --libs)
}

src_install() {
	dobin modplugplay
	dodoc changelog readme
	dohtml modplugplay.html
	doman modplugplay.1
}
