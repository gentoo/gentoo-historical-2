# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/kkeyled/kkeyled-0.8.9.ebuild,v 1.2 2004/08/30 15:43:09 dholm Exp $

inherit kde

need-kde 3

DESCRIPTION="KKeyLED - a Kicker module showing the status of your keyboard's numlock, capslock and scrolllock."
SRC_URI="http://www.truesoft.ch/dieter/kkeyled/software/${P}.tar.gz"
HOMEPAGE="http://www.truesoft.ch/dieter/kkeyled.html"

IUSE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"

src_unpack() {
	unpack ${A}
	einfo "fixing theme paths"
	sed -i -e 's:opt/kde3:usr:g' ${S}/kkeyled/Themicons/kkeyledrc || \
	die "failed to correct theme paths"
}

