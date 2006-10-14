# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnomeui/libgnomeui-2.16.0.ebuild,v 1.2 2006/10/14 21:31:15 vapier Exp $

inherit eutils gnome2

DESCRIPTION="User Interface routines for Gnome"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="doc jpeg"

RDEPEND=">=gnome-base/libgnome-2.13.7
	>=gnome-base/libgnomecanvas-2
	>=gnome-base/libbonoboui-2.13.1
	>=gnome-base/gconf-2
	>=x11-libs/pango-1.1.2
	>=x11-libs/gtk+-2.9
	>=gnome-base/gnome-vfs-2.7.3
	>=gnome-base/libglade-2
	>=gnome-base/gnome-keyring-0.4
	>=dev-libs/popt-1.5
	>=dev-libs/glib-2.8
	jpeg? ( media-libs/jpeg )"

DEPEND="${RDEPEND}
	  sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	doc? ( >=dev-util/gtk-doc-1 )"

PDEPEND="x11-themes/gnome-icon-theme"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="$(use_with jpeg libjpeg)"
}
