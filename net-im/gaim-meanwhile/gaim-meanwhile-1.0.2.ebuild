# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/gaim-meanwhile/gaim-meanwhile-1.0.2.ebuild,v 1.2 2005/01/16 21:49:27 weeve Exp $

inherit debug

DESCRIPTION="Gaim Meanwhile (Sametime protocol) Plugin"
HOMEPAGE="http://meanwhile.sourceforge.net/"
SRC_URI="mirror://sourceforge/meanwhile/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc"
DEPEND="~net-libs/meanwhile-0.3
	>=net-im/gaim-${PV}"
IUSE=""

src_install() {
	make install DESTDIR=${D} || die "Install failed"
	dodoc AUTHORS ChangeLog COPYING INSTALL README
}

