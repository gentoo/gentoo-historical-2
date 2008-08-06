# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/gnome-pilot/gnome-pilot-2.0.16-r1.ebuild,v 1.1 2008/08/06 22:28:25 eva Exp $

inherit gnome2 eutils autotools

DESCRIPTION="Gnome Palm Pilot and Palm OS Device Syncing Library"
HOMEPAGE="http://live.gnome.org/GnomePilot"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="hal"

RDEPEND=">=gnome-base/libgnome-2.0.0
	>=gnome-base/libgnomeui-2.0.0
	>=gnome-base/libglade-2.0.0
	>=gnome-base/orbit-2.6.0
	>=gnome-base/libbonobo-2.0.0
	>=gnome-base/gnome-panel-2.0
	>=gnome-base/gconf-2.0
	dev-libs/libxml2
	>=app-pda/pilot-link-0.11.7
	hal? (
		dev-libs/dbus-glib
		>=sys-apps/hal-0.5.4
	)"

DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/gob-2.0.5
	>=dev-lang/perl-5.6.0
	dev-util/intltool"

DOCS="AUTHORS COPYING* ChangeLog README NEWS"
SCROLLKEEPER_UPDATE="0"

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-usb
		--enable-network
		--enable-pilotlinktest
		$(use_with hal)"
}

src_unpack() {
	gnome2_src_unpack

	echo "libgpilotdCM/gnome-pilot-conduit-management.c" >> po/POTFILES.in

	# Fix --as-needed
	epatch "${FILESDIR}/${PN}-2.0.15-as-needed.patch"

	# Fix use with hal-0.5.11
	epatch "${FILESDIR}/${P}-hal-0.5.11.patch"

	eautoreconf
	intltoolize --force || die
}

pkg_postinst() {
	if ! built_with_use app-pda/pilot-link bluetooth; then
		elog "if you want bluetooth support, please rebuild app-pda/pilot-link"
		elog "echo 'app-pda/pilot-link bluetooth >> /etc/portage/package.use"
	fi
}
