# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/gossip/gossip-0.6.ebuild,v 1.5 2004/06/24 22:52:59 agriffis Exp $

inherit gnome2

DESCRIPTION="Lightweight Jabber client for GNOME"
HOMEPAGE="http://gossip.imendio.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.0.3
	>=x11-libs/gtk+-2.0.4
	>=gnome-base/libglade-2
	>=gnome-base/gconf-1.2
	>=dev-libs/libxml2-2.4.7
	>=dev-libs/libxslt-1.0.0
	>=gnome-base/libgnomeui-2
	>=net-libs/loudmouth-0.14.1"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool"

DOCS="AUTHORS README COPYING ChangeLog INSTALL NEWS README"

src_unpack () {
	unpack ${A}
	cd ${S}
	intltoolize --force
}

