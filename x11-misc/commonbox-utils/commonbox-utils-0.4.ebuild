# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/commonbox-utils/commonbox-utils-0.4.ebuild,v 1.15 2006/09/30 01:34:56 robbat2 Exp $

DESCRIPTION="Common utilities for fluxbox, blackbox, and openbox"
HOMEPAGE="http://mkeadle.org/"
#SRC_URI="mirror://gentoo/${P}.tar.bz2"
SRC_URI="http://mkeadle.org/distfiles/${P}.tar.bz2"
IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha hppa ~amd64 mips ia64 ppc64 ~ppc-macos"

DEPEND="media-gfx/xv"
RDEPEND="${DEPEND}
		|| ( x11-wm/fluxbox x11-wm/blackbox x11-wm/openbox )"

src_compile() {
	./compile.sh
}

src_install() {
	dobin util/{bsetbg,commonbox-menugen,commonbox-imagebgmenugen}
	dodoc README.commonbox-utils AUTHORS COPYING
	doman bsetbg.1

	insinto /usr/share/commonbox
	doins ${S}/solidbgmenu
}

pkg_postinst() {
	${S}/util/commonbox-imagebgmenugen
	${S}/util/commonbox-menugen -kg -o /usr/share/commonbox/menu
}
