# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/guake/guake-0.4.2.ebuild,v 1.6 2012/01/07 16:05:26 sping Exp $

EAPI=3

GCONF_DEBUG=no
PYTHON_DEPEND="2:2.7"

inherit eutils gnome2 python multilib

DESCRIPTION="A dropdown terminal made for the GNOME desktop"
HOMEPAGE="http://guake.org/"
SRC_URI="mirror://debian/pool/main/g/${PN}/${PN}_${PV}.orig.tar.gz"
#SRC_URI="http://guake.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

COMMON_DEPEND=">=x11-libs/gtk+-2.10:2
	dev-python/pygtk
	x11-libs/vte:0[python]
	dev-python/notify-python
	dev-python/gconf-python
	dev-python/dbus-python
	>=gnome-base/gconf-2"
RDEPEND="${COMMON_DEPEND}
	x11-misc/notification-daemon"  # bug 388129
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig
	nls? ( dev-util/intltool )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	G2CONF="--disable-static
		--disable-dependency-tracking
		$(use_enable nls)"
	python_set_active_version 2
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-int-ssl-port.patch \
		"${FILESDIR}"/${P}-prefs-spinbox.patch

	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	find "${D}" -name '*.la' -exec rm -f {} +
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_mod_optimize /usr/$(get_libdir)/${PN}
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup /usr/$(get_libdir)/${PN}
}
