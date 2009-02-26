# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gnome-themes/gnome-themes-2.24.3.ebuild,v 1.3 2009/02/26 01:04:50 leio Exp $

GCONF_DEBUG="no"

inherit eutils gnome2

DESCRIPTION="A set of GNOME themes, with sets for users with limited or low vision"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="accessibility"

RDEPEND=">=x11-libs/gtk+-2
	 >=x11-themes/gtk-engines-2.15.3"
DEPEND="${RDEPEND}
	>=x11-misc/icon-naming-utils-0.8.0
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog NEWS README"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable accessibility all-themes)
		--enable-legacy-icon-mapping"
}

src_unpack() {
	gnome2_src_unpack

	# Fix bashisms, bug #256337
	epatch "${FILESDIR}/${P}-bashism.patch"
}
