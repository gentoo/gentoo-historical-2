# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/gnome-jabber/gnome-jabber-0.3.ebuild,v 1.6 2004/06/24 22:52:15 agriffis Exp $

inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="Gnome Jabber Client"
SRC_URI="mirror://sourceforge/gnome-jabber/${P}.tar.bz2"
HOMEPAGE="http://gnome-jabber.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~sparc"

DEPEND=">=x11-libs/gtk+-2.0.4
	>=gnome-base/libgnomeui-2.0.0
	>=gnome-base/libglade-2.0.0
	>net-libs/gnet-2
	>=gnome-base/gconf-2.0
	>=dev-libs/libxml2-2.4.23
	sys-devel/gettext"
# the dependency on gnome-panel was wrong in configure.in

DOCS="AUTHORS COPYING ChangeLog README NEWS TODO"


