# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmbatteries/wmbatteries-0.1.3.ebuild,v 1.1.1.1 2005/11/30 10:10:36 chriswhite Exp $

inherit eutils

DESCRIPTION="Dock app for monitoring the current battery status and CPU temperature"
HOMEPAGE="http://sourceforge.net/projects/wmbatteries"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/x11"

src_install() {
	einstall || die "Installation failed"
	dodoc AUTHORS THANKS README example/wmbatteriesrc
}
