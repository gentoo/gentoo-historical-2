# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/uf-view/uf-view-2.2.ebuild,v 1.5 2004/06/01 13:28:25 tseng Exp $

inherit gnome2

DESCRIPTION="UF-View is a Gnome viewer for the UserFriendly comic"
HOMEPAGE="http://www.hadess.net/misc-code.php3"
SRC_URI="http://www.hadess.net/files/software/uf-view/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.0
	>=x11-libs/gtk+-2
	>=gnome-base/libgnomeui-2
	>=gnome-base/libglade-2"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog COPYING README INSTALL NEWS TODO"
