# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/streamtuner/streamtuner-0.9.1.ebuild,v 1.10 2004/04/20 16:40:51 eradicator Exp $

IUSE=""

DESCRIPTION="Stream directory browser for browsing internet radio streams"
HOMEPAGE="http://www.nongnu.org/streamtuner/"
SRC_URI="mirror://sourceforge/streamtuner/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86"

DEPEND=">=x11-libs/gtk+-2.0.0
	>=net-misc/curl-7.7.0"

src_install () {
	make DESTDIR=${D} \
		sysconfdir=${D}/etc \
		install || die
	dodoc ChangeLog NEWS INSTALL TODO
}
