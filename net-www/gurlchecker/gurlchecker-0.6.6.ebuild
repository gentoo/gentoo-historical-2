# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/gurlchecker/gurlchecker-0.6.6.ebuild,v 1.3 2004/06/25 00:53:22 agriffis Exp $

inherit gnome2

DESCRIPTION="Gnome tool that checks links on web pages/sites"
HOMEPAGE="http://www.nongnu.org/gurlchecker/"
SRC_URI="http://labs.libre-entreprise.org/download.php/102/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="0"
IUSE=""

RDEPEND=">=gnome-base/libgnomeui-2
	>=gnome-base/libglade-2
	>=dev-libs/libxml2-2
	>=net-libs/gnet-2"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="ABOUT-NLS AUTHORS ChangeLog COPYING NEWS README THANKS TODO"
