# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/system-tray-applet/system-tray-applet-0.15.ebuild,v 1.2 2002/12/07 14:47:26 foser Exp $

inherit gnome2 debug

S=${WORKDIR}/${P}
DESCRIPTION="Systrem tray applet for gnome2"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

RDEPEND=">=dev-libs/glib-2
	>=gnome-base/gnome-panel-2"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0"

DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS  README* THANKS"

		
