# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/acme/acme-1.99.8.ebuild,v 1.1 2002/10/23 23:59:50 foser Exp $

inherit gnome2

IUSE="gnome"

S=${WORKDIR}/${P}
DESCRIPTION="GNOME tool to make use of the multimedia buttons present on most laptops and internet keyboards."
SRC_URI="http://www.hadess.net/files/software/acme/${P}.tar.gz"
HOMEPAGE="http://www.hadess.net/misc-code.php3"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86"

DEPEND=">=dev-util/intltool-0.20
	>=gnome-base/libgnomeui-2
	>=gnome-base/libglade-2"

RDEPEND="${DEPEND}
	sys-devel/gettext
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog COPYING INSTALL NEWS README"
