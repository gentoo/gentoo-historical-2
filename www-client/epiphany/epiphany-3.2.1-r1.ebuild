# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/epiphany/epiphany-3.2.1-r1.ebuild,v 1.2 2012/03/06 16:24:34 tetromino Exp $

EAPI="4"
GCONF_DEBUG="yes"

inherit autotools eutils gnome2 pax-utils

DESCRIPTION="GNOME webbrowser based on Webkit"
HOMEPAGE="http://projects.gnome.org/epiphany/"

LICENSE="GPL-2"
SLOT="0"
IUSE="avahi doc +introspection +networkmanager +nss test"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

# XXX: Should we add seed support? Seed seems to be unmaintained now.
# Require {glib,gdbus-codegen}-2.30.0 due to GDBus API changes between 2.29.92
# and 2.30.0
COMMON_DEPEND=">=dev-libs/glib-2.30.0:2
	>=x11-libs/gtk+-3.0.2:3[introspection?]
	>=dev-libs/libxml2-2.6.12:2
	>=dev-libs/libxslt-1.1.7
	>=app-text/iso-codes-0.35
	>=net-libs/webkit-gtk-1.6.1:3[introspection?]
	>=net-libs/libsoup-gnome-2.33.1:2.4
	>=gnome-base/gnome-keyring-2.26.0
	>=gnome-base/gsettings-desktop-schemas-0.0.1
	>=x11-libs/libnotify-0.5.1

	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11

	app-misc/ca-certificates
	x11-themes/gnome-icon-theme

	avahi? ( >=net-dns/avahi-0.6.22 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	nss? ( dev-libs/nss )"
# networkmanager is used purely via dbus
RDEPEND="${COMMON_DEPEND}
	x11-themes/gnome-icon-theme-symbolic
	networkmanager? ( >=net-misc/networkmanager-0.8.997 )"
# paxctl needed for bug #407085
DEPEND="${COMMON_DEPEND}
	app-text/gnome-doc-utils
	>=dev-util/gdbus-codegen-2.30.0
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	sys-apps/paxctl
	sys-devel/gettext
	doc? ( >=dev-util/gtk-doc-1 )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog* HACKING MAINTAINERS NEWS README TODO"
	G2CONF="${G2CONF}
		--enable-shared
		--disable-schemas-compile
		--disable-scrollkeeper
		--disable-static
		--with-distributor-name=Gentoo
		--with-ca-file=${EPREFIX}/etc/ssl/certs/ca-certificates.crt
		$(use_enable avahi zeroconf)
		$(use_enable introspection)
		$(use_enable nss)
		$(use_enable test tests)"
	# Upstream no longer makes networkmanager optional, but we still want
	# to make it possible for prefix users to use epiphany
	use networkmanager && CFLAGS="${CFLAGS} -DENABLE_NETWORK_MANAGER"
}

src_prepare() {
	# Make networkmanager optional for prefix people
	epatch "${FILESDIR}/${PN}-3.2.0-optional-networkmanager.patch"
	# Build-time segfaults under PaX with USE=introspection
	epatch "${FILESDIR}/${PN}-3.2.1-paxctl-introspection.patch"
	cp "${FILESDIR}/gir-paxctl-lt-wrapper" \
		"${FILESDIR}/paxctl.sh" "${S}/" || die
	sed -e "s:@S@:${S}:" -i gir-paxctl-lt-wrapper || die
	eautoreconf
	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	pax-mark m "${ED}usr/bin/epiphany"
}
