# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/acme/acme-2.0.2.ebuild,v 1.10 2003/08/07 03:40:07 vapier Exp $

inherit gnome2

DESCRIPTION="GNOME tool to make use of the multimedia buttons present on most laptops and internet keyboards."
HOMEPAGE="http://www.hadess.net/misc-code.php3"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc alpha sparc"
IUSE="gnome"

DEPEND=">=gnome-base/libgnomeui-2
	>=gnome-base/libglade-2
	>=x11-libs/libwnck-2.1.5"
RDEPEND="${DEPEND}
	>=gnome-base/gconf-1.2
	>=dev-util/intltool-0.20
	sys-devel/gettext
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog COPYING INSTALL NEWS README"
