# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/mlview/mlview-0.8-r1.ebuild,v 1.3 2006/02/08 00:27:32 metalgod Exp $

inherit eutils gnome2

DESCRIPTION="XML editor for the GNOME environment"
HOMEPAGE="http://www.freespiders.org/projects/gmlview/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~x86"
IUSE=""

RDEPEND=">=dev-libs/libxml2-2.6.11
	>=dev-libs/libxslt-1.1.8
	>=dev-libs/glib-2.4.6
	>=x11-libs/gtk+-2.4.3
	>=gnome-base/libglade-2.4
	>=gnome-base/libgnome-2.6.1
	>=gnome-base/gconf-2.6.2
	>=gnome-base/eel-2.6.2
	>=x11-libs/gtksourceview-1
	sys-libs/zlib"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.33
	>=dev-util/pkgconfig-0.9"

DOCS="ABOUT-NLS AUTHORS BRANCHES ChangeLog COPYRIGHT NEWS README"


src_unpack() {
	unpack "${A}"
	cd "${S}"

	# Small corrections for mlview.desktop
	epatch ${FILESDIR}/${P}-dot_desktop.patch
}
