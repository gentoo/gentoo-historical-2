# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmxmms/wmxmms-0.1.4.ebuild,v 1.2 2003/10/16 16:10:23 drobbins Exp $


MY_P=${P/wm/WM}
S=${WORKDIR}/${MY_P}
DESCRIPTION="WMaker DockApp: XMMS Control App"
HOMEPAGE="http://www.dockapps.com/file.php/id/172/"
SRC_URI="http://www.dockapps.com/download.php/id/252/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~mips ~arm amd64"

DEPEND="virtual/x11
	media-sound/xmms"

src_compile() {
	econf || die
	emake OPT="${CFLAGS}" || die
}

src_install() {
	dobin src/WMxmms
	dodoc AUTHORS ChangeLog README THANKS TODO
	doman doc/WMxmms.1
}
