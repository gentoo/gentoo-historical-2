# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/downman/downman-0.0.4.ebuild,v 1.1 2005/03/17 17:52:13 seemant Exp $

inherit gnome2

DESCRIPTION="Download Manager (aka downman) is a suite of programs to download files"
HOMEPAGE="http://downman.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ppc ~sparc ~alpha amd64"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.0
	>=dev-libs/glib-2.0
	>=gnome-base/libgnome-2.0
	>=gnome-base/libgnomeui-2.0
	>=gnome-base/libglade-2.0
	>=dev-libs/libxml2-2.0"

DOCS="ABOUT-NLS AUTHORS ChangeLog COPYING README INSTALL NEWS"
