# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gucharmap/gucharmap-1.4.1.ebuild,v 1.10 2004/08/07 23:09:00 slarti Exp $

inherit gnome2 eutils

DESCRIPTION="Unicode character map viewer"
HOMEPAGE="http://gucharmap.sourceforge.net/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="x86 ppc alpha sparc hppa amd64 ~ia64 mips"
IUSE="gnome cjk"

RDEPEND=">=dev-libs/glib-2.3
	>=x11-libs/pango-1.2.1
	>=x11-libs/gtk+-2.2
	dev-libs/popt
	gnome? ( >=gnome-base/libgnome-2.2
		 >=gnome-base/libgnomeui-2.2 )
	!<gnome-extra/gnome-utils-2.3"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	app-text/scrollkeeper
	>=dev-util/intltool-0.29"

G2CONF="${G2CONF} $(use_enable gnome) $(use_enable cjk unihan)"

DOCS="COPYING* ChangeLog INSTALL README TODO"
