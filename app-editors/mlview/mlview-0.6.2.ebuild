# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/mlview/mlview-0.6.2.ebuild,v 1.2 2004/04/19 08:54:05 dholm Exp $

inherit gnome2

DESCRIPTION="MLview is an XML editor for the GNOME environment"
HOMEPAGE="http://www.freespiders.org/projects/gmlview/"
LICENSE="GPL-2"

IUSE=""
SLOT="0"
KEYWORDS="x86 ~ppc"

RDEPEND=">=gnome-base/libgnomeui-2.2
	>=gnome-base/libgnome-2.2
	>=gnome-base/gconf-2.2
	>=dev-libs/libxml2-2.4.30
	>=dev-libs/libxslt-1.0.33
	>=dev-libs/glib-2.2
	>=x11-libs/gtk+-2.2
	>=gnome-base/libglade-2
	>=gnome-base/eel-2.2"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.25
	sys-devel/gettext
	dev-util/pkgconfig"

DOCS="ABOUT-NLS AUTHORS BRANCHES COPYING ChangeLog INSTALL NEWS README"
USE_DESTDIR="1"

