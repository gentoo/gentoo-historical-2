# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vinagre/vinagre-2.24.1.ebuild,v 1.1 2008/10/20 19:18:50 eva Exp $

inherit gnome2 eutils

DESCRIPTION="VNC Client for the GNOME Desktop"
HOMEPAGE="http://www.gnome.org/projects/vinagre/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

# FIXME: make avahi optional again ?

RDEPEND=">=dev-libs/glib-2.17.0
	>=x11-libs/gtk+-2.13.1
	>=gnome-base/libglade-2.6
	>=gnome-base/gconf-2.16
	>=net-libs/gtk-vnc-0.3.7
	>=gnome-base/gnome-keyring-1
	>=gnome-base/gnome-panel-2
	>=net-dns/avahi-0.6.22"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	app-text/scrollkeeper
	app-text/gnome-doc-utils
	test? ( ~app-text/docbook-xml-dtd-4.3 )"

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"

pkg_setup() {
	if ! built_with_use net-dns/avahi gtk; then
		eerror "gtk support in avahi needed"
		die "Please rebuild avahi with USE='gtk'"
	fi

	G2CONF="${G2CONF} --disable-scrollkeeper --disable-rebuilds"
}

src_install() {
	gnome2_src_install

	# Remove it's own installation of DOCS that go to $PN instead of $P and aren't ecompressed
	rm -rf "${D}"/usr/share/doc/vinagre
}
