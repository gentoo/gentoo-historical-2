# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/jnettop/jnettop-0.9.ebuild,v 1.3 2004/06/24 22:05:57 agriffis Exp $

DESCRIPTION="A top like console network traffic visualiser"
HOMEPAGE="http://jnettop.kubs.info/"
SRC_URI="http://jnettop.kubs.info/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="net-libs/libpcap
	>=dev-libs/glib-2.0"

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog INSTALL NEWS README
}
