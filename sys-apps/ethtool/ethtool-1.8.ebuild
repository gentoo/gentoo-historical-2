# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/ethtool/ethtool-1.8.ebuild,v 1.1.1.1 2005/11/30 09:56:24 chriswhite Exp $

DESCRIPTION="Utility for examining and tuning ethernet-based network interfaces"
HOMEPAGE="http://sourceforge.net/projects/gkernel/"
SRC_URI="mirror://sourceforge/gkernel/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 alpha sparc ppc hppa ia64 ppc64"
IUSE=""

src_install() {
	einstall || die
	dodoc NEWS README INSTALL
}
