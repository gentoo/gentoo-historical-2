# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gconf-editor/gconf-editor-0.4.0.ebuild,v 1.4 2003/02/13 12:17:27 vapier Exp $ 

inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="an editor to the GConf2 system"
HOMEPAGE="http://www.gnome.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc alpha"

RDEPEND=">=gnome-base/gconf-1.2.1
	>=x11-libs/gtk+-2.0.2"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0"

DOCS="AUTHORS ChangeLog COPYING README INSTALL NEWS"
