# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/gnunet-gtk/gnunet-gtk-0.7.3.ebuild,v 1.2 2008/02/19 02:58:52 ranger Exp $

DESCRIPTION="Graphical front end for GNUnet."
HOMEPAGE="http://gnunet.org/"
SRC_URI="http://gnunet.org/download/${P}.tar.bz2"

KEYWORDS="~amd64 ~ppc64 ~x86"
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
	make DESTDIR="${D}" -j1 install || die
}
