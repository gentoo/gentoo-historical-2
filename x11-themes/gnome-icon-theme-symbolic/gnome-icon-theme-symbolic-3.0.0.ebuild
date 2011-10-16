# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gnome-icon-theme-symbolic/gnome-icon-theme-symbolic-3.0.0.ebuild,v 1.5 2011/10/16 17:46:23 xarthisius Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Symbolic icons for GNOME default icon theme"
HOMEPAGE="http://www.gnome.org/"

LICENSE="CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ppc ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=x11-themes/hicolor-icon-theme-0.10"
DEPEND="${RDEPEND}
	>=x11-misc/icon-naming-utils-0.8.7
	>=dev-util/pkgconfig-0.19"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

# FIXME: double check potential LINGUAS problem
src_prepare() {
	DOCS="AUTHORS NEWS"
	G2CONF="${G2CONF}
		--enable-icon-mapping
		GTK_UPDATE_ICON_CACHE=$(type -P true)"
}
