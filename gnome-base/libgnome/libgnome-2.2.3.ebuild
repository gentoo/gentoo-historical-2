# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnome/libgnome-2.2.3.ebuild,v 1.4 2003/08/25 23:45:20 tester Exp $

IUSE="doc"

inherit gnome2

DESCRIPTION="Essential Gnome Libraries"
HOMEPAGE="http://www.gnome.org/"

SLOT="0"
KEYWORDS="x86 ~ppc ~alpha ~sparc ~hppa ~amd64"
LICENSE="GPL-2 LGPL-2.1"

RDEPEND=">=dev-libs/glib-2.0.3
	>=gnome-base/gconf-1.2
	>=gnome-base/libbonobo-2
	>=gnome-base/gnome-vfs-2
	>=media-sound/esound-0.2.26
	>=media-libs/audiofile-0.2.3
	>=dev-libs/libxml2-2.4.22
	>=dev-libs/libxslt-1.0.18"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.21
	>=dev-util/pkgconfig-0.12.0
	doc? ( >=dev-util/gtk-doc-0.6 )"

DOCS="AUTHORS COPYING* ChangeLog INSTALL NEWS README"

# fix for sandbox violations see bug #24359
# Obz <obz@gentoo.org>
G2CONF="${G2CONF} --disable-schemas-install"
