# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellm-giFT/gkrellm-giFT-0.2.1.ebuild,v 1.7 2004/08/23 03:02:35 squinky86 Exp $

DESCRIPTION="GKrellM2 plugin to monitor giFT transfers"
SRC_URI="ftp://ftp-monkey.de/pub/gkrellm-gift/${P}.tar.gz"
HOMEPAGE="http://code-monkey.de/?gkrellm-gift"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=">=app-admin/gkrellm-2.1.15
	>=net-p2p/gift-0.11.3"

src_compile() {
	econf || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog COPYING FAQ README
}
