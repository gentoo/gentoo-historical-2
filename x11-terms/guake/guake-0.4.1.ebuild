# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/guake/guake-0.4.1.ebuild,v 1.1 2010/04/14 12:23:42 ssuominen Exp $

EAPI=2

GCONF_DEBUG=no
PYTHON_DEPEND="2:2.6"

inherit gnome2 python multilib

DESCRIPTION="A dropdown terminal made for the GNOME desktop"
HOMEPAGE="http://guake.org/"
SRC_URI="http://guake.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.10:2
	dev-python/pygtk
	x11-libs/vte[python]
	dev-python/notify-python
	dev-python/gconf-python
	>=gnome-base/gconf-2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	G2CONF="--disable-static
		--disable-dependency-tracking"
	python_set_active_version 2
}

src_install() {
	gnome2_src_install
	find "${D}" -name '*.la' -delete
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_mod_optimize /usr/$(get_libdir)/${PN}
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup /usr/$(get_libdir)/${PN}
}
