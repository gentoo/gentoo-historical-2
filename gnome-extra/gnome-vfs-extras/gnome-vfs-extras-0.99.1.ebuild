# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-vfs-extras/gnome-vfs-extras-0.99.1.ebuild,v 1.9 2003/02/13 12:19:49 vapier Exp $

IUSE="doc"

inherit gnome2
S=${WORKDIR}/${P}
DESCRIPTION="the Gnome Virtual Filesystem extra libraries"
SRC_URI="mirror://gnome/2.0.0/sources/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"
SLOT="1"
LICENSE="GPL-2"
KEYWORDS="x86 sparc "

RDEPEND=">=dev-libs/glib-2.0.3
	>=gnome-base/gconf-1.2.0
	>=gnome-base/ORBit2-2.4.0
	>=gnome-base/gnome-mime-data-2.0.0
	>=gnome-base/gnome-vfs-2.0.1
	>=sys-devel/gettext-0.10.40"

DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )
	>=dev-util/pkgconfig-0.12.0"
	
DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS  README"
