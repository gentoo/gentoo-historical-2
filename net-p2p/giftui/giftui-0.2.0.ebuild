# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/giftui/giftui-0.2.0.ebuild,v 1.4 2004/03/13 10:14:14 eradicator Exp $

DESCRIPTION="A GTK+2 giFT frontend"
HOMEPAGE="http://giftui.tuxfamily.org/"
SRC_URI="http://giftui.tuxfamily.org/downloads/sources/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND=">=x11-libs/gtk+-2.0.3
	net-p2p/gift"

S="${WORKDIR}/${P}"

src_install() {
	make DESTDIR=${D} giftuidocdir=/usr/share/doc/${PF} install
#	prepall
	prepalldocs
}
