# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mp3gain/mp3gain-1.4.5.ebuild,v 1.3 2005/08/23 22:06:40 chainsaw Exp $

IUSE=""

MY_P=${P//./_}
S=${WORKDIR}

DESCRIPTION="MP3Gain automatically adjusts mp3s so that they all have the same volume"
HOMEPAGE="http://mp3gain.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-src.zip"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc x86"

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}
	app-arch/unzip"

src_compile() {
	sed -i 's:INSTALL_PATH= /usr/local/bin:INSTALL_PATH= /usr/bin:' Makefile

	emake || die
}

src_install () {
	dobin mp3gain
}
