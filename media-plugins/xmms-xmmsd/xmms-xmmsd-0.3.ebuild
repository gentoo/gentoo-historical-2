# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-xmmsd/xmms-xmmsd-0.3.ebuild,v 1.1.1.1 2005/11/30 10:07:30 chriswhite Exp $

IUSE=""

MY_P=${P/xmms-/}
MY_PN=${PN/xmms-/}
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Web interface for controlling xmms"
HOMEPAGE="http://xmmsd.sourceforge.net/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
#-sparc: 0.3: enabling plugin causes xmms to segfault
KEYWORDS="amd64 ~ppc -sparc x86"

DEPEND="media-sound/xmms"

src_compile() {
	econf || die
	emake -j1 || die
}

src_install() {
	dobin src/xmmsd
	exeinto `xmms-config --general-plugin-dir`
	doexe src/.libs/libxmmsd.so

	dodoc AUTHORS ChangeLog HACKING NEWS README README.libtaglist THANKS TODO
}
