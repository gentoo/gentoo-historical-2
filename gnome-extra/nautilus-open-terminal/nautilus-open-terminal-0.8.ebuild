# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/nautilus-open-terminal/nautilus-open-terminal-0.8.ebuild,v 1.4 2007/12/13 15:47:57 armin76 Exp $

inherit gnome2

DESCRIPTION="Nautilus Plugin for Opening Terminals"
HOMEPAGE="http://manny.cluecoder.org/packages/nautilus-open-terminal/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc sparc x86"
IUSE=""

RDEPEND=">=gnome-base/eel-2.6
		 >=x11-libs/gtk+-2.4.0
		 >=dev-libs/glib-2.6.0
		 >=gnome-base/nautilus-2.17.2
		 >=gnome-base/gnome-desktop-2.9.91
		 >=gnome-base/gconf-2.0.0"
DEPEND="${RDEPEND}
		sys-devel/gettext
		dev-util/pkgconfig
		>=dev-util/intltool-0.18"

DOCS="AUTHORS ChangeLog INSTALL NEWS README TODO"
