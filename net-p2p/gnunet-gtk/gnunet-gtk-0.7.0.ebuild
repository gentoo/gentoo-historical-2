# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/gnunet-gtk/gnunet-gtk-0.7.0.ebuild,v 1.2 2005/10/04 19:35:36 mkay Exp $

DESCRIPTION="Graphical front end for GNUnet."
HOMEPAGE="http://www.gnu.org/software/GNUnet/"
SRC_URI="mirror://gnu//gnunet/${P}.tar.bz2"

KEYWORDS="~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.6.0
	>=net-p2p/gnunet-${PV}
	>=gnome-base/libglade-2.0"

src_compile() {
	econf --with-gnunet=/usr || die "econf failed"
	emake -j1 || die "emake failed"
}

src_install() {
	make install DESTDIR=${D} install || die
}
