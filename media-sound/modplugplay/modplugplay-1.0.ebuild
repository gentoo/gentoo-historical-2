# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/modplugplay/modplugplay-1.0.ebuild,v 1.6 2007/10/27 13:44:49 drac Exp $

inherit toolchain-funcs

DESCRIPTION="A commandline player for mod music"
HOMEPAGE="http://www.linuks.mine.nu/modplugplay/"
SRC_URI="http://www.linuks.mine.nu/modplugplay/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
#-sparc: 1.0 - Bus Error on play
KEYWORDS="amd64 ~hppa ~ppc -sparc x86"
IUSE=""

RDEPEND=">=media-libs/libmodplug-0.7"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

RESTRICT="test"

src_compile() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o modplugplay modplugplay.c $(pkg-config libmodplug --cflags --libs)
}

src_install() {
	dobin modplugplay
	dodoc changelog readme
	dohtml modplugplay.html
	doman modplugplay.1
}
