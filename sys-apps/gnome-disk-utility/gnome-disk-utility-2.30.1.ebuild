# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/gnome-disk-utility/gnome-disk-utility-2.30.1.ebuild,v 1.2 2010/06/16 12:07:52 pacho Exp $

EAPI="2"
GCONF_DEBUG="no"

inherit autotools eutils gnome2

DESCRIPTION="Disk Utility for GNOME using devicekit-disks"
HOMEPAGE="http://git.gnome.org/cgit/gnome-disk-utility/"
SRC_URI="http://hal.freedesktop.org/releases/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~sh ~x86"
IUSE="avahi doc fat +nautilus remote-access"

RDEPEND="
	>=dev-libs/glib-2.22
	>=dev-libs/dbus-glib-0.74
	>=dev-libs/libunique-1.0
	>=x11-libs/gtk+-2.17.2
	=sys-fs/udisks-1.0*[remote-access?]
	>=dev-libs/libatasmart-0.14
	>=gnome-base/gnome-keyring-2.22
	>=x11-libs/libnotify-0.3

	avahi? ( >=net-dns/avahi-0.6.25[gtk] )
	fat? ( sys-fs/dosfstools )
	nautilus? ( >=gnome-base/nautilus-2.24 )

	!!sys-apps/udisks"
DEPEND="${RDEPEND}
	sys-devel/gettext
	gnome-base/gnome-common
	app-text/scrollkeeper
	app-text/gnome-doc-utils

	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	>=dev-util/gtk-doc-am-1.13

	doc? ( >=dev-util/gtk-doc-1.3 )"
DOCS="AUTHORS NEWS README TODO"

src_prepare() {
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable avahi avahi-ui)
		$(use_enable nautilus)
		$(use_enable remote-access)"

	epatch "${FILESDIR}/${P}-optional-avahi.patch"

	# Drop encoding from POTFILES.skip, see bug #313351
	epatch "${FILESDIR}/${PN}-2.28.1-fix-potfiles_skip.patch"

	eautoreconf
}

src_install() {
	gnome2_src_install
	find "${D}" -name "*.la" -delete || die "remove of la files failed"
}
