# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/giftui/giftui-0.1.1.ebuild,v 1.3 2004/03/13 10:14:14 eradicator Exp $

MY_P="giFTui-${PV}"
DESCRIPTION="A GTK+2 giFT frontend"
HOMEPAGE="http://giftui.tuxfamily.org/"
SRC_URI="http://giftui.tuxfamily.org/downloads/sources/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND=">=x11-libs/gtk+-2.0.3
	net-p2p/gift"

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf || die "Configure failed"
	emake || die "Make failed"
}

src_install() {
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README TODO ABOUT-NLS
	einstall prefix=${D}/usr exec_prefix=${D}/usr|| die "Install failed"
}
