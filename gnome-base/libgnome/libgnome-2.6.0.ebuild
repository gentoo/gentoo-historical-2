# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnome/libgnome-2.6.0.ebuild,v 1.10 2005/01/08 23:38:54 slarti Exp $

inherit gnome2

DESCRIPTION="Essential Gnome Libraries"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="x86 ppc alpha ~sparc hppa amd64 ia64 mips arm"
IUSE="doc"

RDEPEND=">=dev-libs/glib-2.0.3
	>=gnome-base/gconf-2
	>=gnome-base/libbonobo-2
	>=gnome-base/gnome-vfs-2.5.3
	>=media-sound/esound-0.2.26
	>=media-libs/audiofile-0.2.3
	>=dev-libs/popt-1.5"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.29
	>=dev-util/pkgconfig-0.12.0
	doc? ( >=dev-util/gtk-doc-0.6 )"

G2CONF="${G2CONF} --disable-schemas-install "

DOCS="AUTHORS COPYING* ChangeLog INSTALL NEWS README"
