# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vinagre/vinagre-2.24.2-r1.ebuild,v 1.8 2009/03/18 15:13:59 armin76 Exp $

EAPI=2

inherit autotools gnome2 eutils

DESCRIPTION="VNC Client for the GNOME Desktop"
HOMEPAGE="http://www.gnome.org/projects/vinagre/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE="avahi test"

# FIXME: make gnome-panel applet optional?

RDEPEND=">=dev-libs/glib-2.17.0
	>=x11-libs/gtk+-2.13.1
	>=gnome-base/libglade-2.6
	>=gnome-base/gconf-2.16
	>=net-libs/gtk-vnc-0.3.7
	>=gnome-base/gnome-keyring-1
	>=gnome-base/gnome-panel-2
	avahi? ( >=net-dns/avahi-0.6.22[dbus,gtk] )"

DEPEND="${RDEPEND}
	gnome-base/gnome-common
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	app-text/scrollkeeper
	app-text/gnome-doc-utils
	test? ( ~app-text/docbook-xml-dtd-4.3 )"

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"

pkg_setup() {
	G2CONF="${G2CONF} $(use_enable avahi)
		--disable-scrollkeeper --disable-rebuilds"
}

src_prepare()
{
	gnome2_src_prepare

	# Support enabling/disabling of Avahi support (bug #243004)
	epatch "${FILESDIR}/${P}-optional-avahi.patch"

	eautoreconf
}

src_install() {
	gnome2_src_install

	# Remove it's own installation of DOCS that go to $PN instead of $P and aren't ecompressed
	rm -rf "${D}"/usr/share/doc/vinagre
}
