# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/ggv/ggv-2.6.0.ebuild,v 1.6 2004/06/03 23:07:43 geoman Exp $

inherit gnome2

DESCRIPTION="The GNOME PostScript document viewer"
HOMEPAGE="http://www.gnome.org/"
LICENSE="GPL-2 FDL-1.1"

IUSE=""
SLOT="0"
KEYWORDS="x86 ppc ~alpha ~sparc hppa ~amd64 ~ia64 mips"

RDEPEND=">=x11-libs/gtk+-2.3
	>=gnome-base/libgnomeui-2.5
	>=gnome-base/ORBit2-2.4.1
	virtual/ghostscript
	dev-libs/popt"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	>=dev-util/intltool-0.30"

DOCS="AUTHORS ChangeLog COPYING* INSTALL MAINTAINERS TODO README"
