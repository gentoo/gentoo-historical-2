# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/nautilus-open-terminal/nautilus-open-terminal-0.6.ebuild,v 1.6 2006/03/05 16:19:08 weeve Exp $

inherit gnome2

DESCRIPTION="Nautilus Plugin for Opening Terminals"
HOMEPAGE="http://manny.cluecoder.org/packages/nautilus-open-terminal/"
SRC_URI="http://manny.cluecoder.org/packages/nautilus-open-terminal/${PF}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc sparc x86"
IUSE=""

RDEPEND=">=gnome-base/nautilus-2.6.0
		 >=gnome-base/gnome-desktop-2.9.91
		 >=dev-libs/glib-2.6.0
		 >=x11-libs/gtk+-2.4.0
		   gnome-base/gconf"
DEPEND="${RDEPEND}
		dev-util/pkgconfig
		dev-util/intltool"

USE_DESTDIR=1
DOCS="AUTHORS ChangeLog INSTALL NEWS README TODO"
