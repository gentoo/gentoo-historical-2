# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/downman/downman-0.0.5.ebuild,v 1.7 2005/02/20 12:38:29 luckyduck Exp $

inherit eutils gnome2

DESCRIPTION="Download Manager (aka downman) is a suite of programs to download files"
HOMEPAGE="http://downman.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ppc ~sparc alpha amd64"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.0
	>=dev-libs/glib-2.0
	>=gnome-base/libgnome-2.0
	>=gnome-base/libgnomeui-2.0
	>=gnome-base/libglade-2.0
	>=dev-libs/libxml2-2.0"

DOCS="ABOUT-NLS AUTHORS ChangeLog COPYING README INSTALL NEWS"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${PV}-gcc34.patch
}
