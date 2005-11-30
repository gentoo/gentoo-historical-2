# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/libmnetutil/libmnetutil-0.3.0.ebuild,v 1.1.1.1 2005/11/30 09:54:57 chriswhite Exp $

IUSE=""
DESCRIPTION="Minisip basic networking library"
HOMEPAGE="http://www.minisip.org/"
SRC_URI="http://www.minisip.org/source/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND="~net-misc/libmutil-0.3.0"

src_install() {
	make DESTDIR="${D}" install || die
}
