# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/netleds_applet/netleds_applet-0.9.1-r3.ebuild,v 1.8 2003/09/05 23:40:10 msterret Exp $


S=${WORKDIR}/${P}
DESCRIPTION="Gnome applet that displays leds from network load"
SRC_URI="http://netleds.port5.com/${P}.tar.gz"
HOMEPAGE="http://netleds.port5.com/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc "

DEPEND=">=gnome-base/gnome-core-1.4.0.4-r1
	>=gnome-base/libgtop-1.0.12-r1"

src_compile() {

	econf || die
	emake || die
}

src_install() {

	einstall || die

	dodoc AUTHORS COPYING ChangeLog NEWS README TODO
}
