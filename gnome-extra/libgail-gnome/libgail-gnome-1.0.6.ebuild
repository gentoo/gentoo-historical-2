# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/libgail-gnome/libgail-gnome-1.0.6.ebuild,v 1.2 2005/01/08 23:40:20 slarti Exp $

inherit gnome2

DESCRIPTION="GAIL libraries for Gnome2 "
HOMEPAGE="http://developer.gnome.org/projects/gap/"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~amd64 ~ia64 ~mips"
LICENSE="LGPL-2"
IUSE=""

RDEPEND=">=dev-libs/atk-1.6
	>=gnome-base/gnome-panel-0.0.18
	>=gnome-base/libbonoboui-1.1
	>=gnome-base/libbonobo-1.1
	>=gnome-base/libgnomeui-1.1
	>=gnome-extra/at-spi-0.10
	>=x11-libs/gtk+-1.3.11"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog NEWS README"
