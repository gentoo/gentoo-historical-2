# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-menus/gnome-menus-2.16.1.ebuild,v 1.7 2006/12/21 12:45:03 corsair Exp $

inherit eutils gnome2

DESCRIPTION="The GNOME menu system, implementing the F.D.O cross-desktop spec"
HOMEPAGE="http://www.gnome.org"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ppc ppc64 ~sh sparc x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.6
	>=gnome-base/gnome-vfs-2.8.2
	>=dev-lang/python-2.2
	dev-python/pygtk"
DEPEND="${RDEPEND}
	  sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog HACKING NEWS README"

src_unpack() {
	gnome2_src_unpack

	# Add a couple of important LegacyDir entries. See bug #97839.
	epatch "${FILESDIR}/${PN}-2.10.2-legacy_dirs.patch"
}
