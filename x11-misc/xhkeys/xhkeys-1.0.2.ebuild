# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xhkeys/xhkeys-1.0.2.ebuild,v 1.1 2004/07/03 14:55:10 pyrania Exp $

DESCRIPTION="assign particular actions to any key or key combination"
HOMEPAGE="http://www.geocities.com/wmalms/"
SRC_URI="http://www.geocities.com/wmalms/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/x11"

src_install() {
	dobin xhkeys xhkconf
	dodoc README VERSION
}
