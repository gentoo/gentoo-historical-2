# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmseti/wmseti-1.0.3.ebuild,v 1.3 2004/07/17 05:31:49 s4t4n Exp $

IUSE=""

DESCRIPTION="WMaker DockApp to see the progress of work unit analysis for the Seti@Home project."
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

HOMEPAGE="http://wmseti.sourceforge.net/"

SLOT="0"
KEYWORDS="x86"
LICENSE="GPL-2"

DEPEND="virtual/x11"

src_install () {
	einstall || die "make install failed"
	dodoc AUTHORS ChangeLog INSTALL NEWS README
}
