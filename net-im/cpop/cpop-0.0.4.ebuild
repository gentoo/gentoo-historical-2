# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/cpop/cpop-0.0.4.ebuild,v 1.4 2004/06/24 22:50:07 agriffis Exp $

DESCRIPTION="GTK+ network popup message client. Compatable with the jpop protocol."
HOMEPAGE="http://www.draxil.uklinux.net/hip/index.pl?page=cpop"
SRC_URI="http://www.draxil.uklinux.net/hip/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.2.0
		>=dev-libs/glib-2.0.0"

src_install() {
	einstall || die
	dodoc COPYING ChangeLog INSTALL README
}
