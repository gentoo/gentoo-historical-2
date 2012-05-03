# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/ghex/ghex-3.0.0.ebuild,v 1.7 2012/05/03 18:33:01 jdhore Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Gnome hexadecimal editor"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 FDL-1.1"
SLOT="2"
KEYWORDS="amd64 ppc x86 ~x86-interix ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=dev-libs/glib-2.26:2
	>=x11-libs/gtk+-3.0:3
	>=dev-libs/atk-1"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.41.1
	>=app-text/gnome-doc-utils-0.9.0
	>=sys-devel/gettext-0.17"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		--disable-schemas-compile
		--disable-scrollkeeper
		--disable-static"
}
