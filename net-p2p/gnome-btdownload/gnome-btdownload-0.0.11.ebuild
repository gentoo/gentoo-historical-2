# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/gnome-btdownload/gnome-btdownload-0.0.11.ebuild,v 1.2 2004/07/03 11:22:11 dholm Exp $

inherit gnome2

DESCRIPTION="A work-in-progress Gnome mime-sink for BitTorrent files"
HOMEPAGE="http://gnome-bt.sourceforge.net/"
SRC_URI="mirror://sourceforge/gnome-bt/${P}.tar.bz2"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"
SLOT="0"
IUSE=""

RDEPEND=">=dev-lang/python-2.3
	>=dev-python/pygtk-2.2
	>=dev-python/gnome-python-2.0
	>=net-p2p/bittorrent-3.4"

DEPEND="${RDEPEND}
	>=app-text/scrollkeeper-0.3.11
	>=dev-util/pkgconfig-0.12.0
	>=dev-util/intltool-0.21"

DOCS="AUTHORS ChangeLog HACKING INSTALL NEWS README"
