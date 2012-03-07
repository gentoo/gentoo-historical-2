# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-color-manager/gnome-color-manager-3.2.2-r1.ebuild,v 1.1 2012/03/07 23:04:30 tetromino Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Color profile manager for the GNOME desktop"
HOMEPAGE="http://projects.gnome.org/gnome-color-manager/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="clutter packagekit raw"

# FIXME: fix detection of docbook2man
COMMON_DEPEND=">=dev-libs/glib-2.30.0:2

	>=media-libs/lcms-2.2:2
	>=media-libs/libcanberra-0.10[gtk3]
	media-libs/libexif
	media-libs/tiff

	x11-libs/libX11
	x11-libs/libXrandr
	>=x11-libs/gtk+-2.91:3
	>=x11-libs/vte-0.25.1:2.90
	>=x11-misc/colord-0.1.12

	clutter? (
		media-libs/clutter-gtk:1.0
		media-libs/mash:0.2 )
	packagekit? ( app-admin/packagekit-base )
	raw? ( media-gfx/exiv2 )
"
RDEPEND="${COMMON_DEPEND}
	media-gfx/shared-color-profiles
"
# docbook-sgml-{utils,dtd:4.1} needed to generate man pages
DEPEND="${COMMON_DEPEND}
	app-text/docbook-sgml-dtd:4.1
	app-text/docbook-sgml-utils
	app-text/gnome-doc-utils
	dev-libs/libxslt
	>=dev-util/intltool-0.35
"

# FIXME: run test-suite with files on live file-system
RESTRICT="test"

pkg_setup() {
	# Always enable tests since they are check_PROGRAMS anyway
	G2CONF="${G2CONF}
		--disable-static
		--disable-schemas-compile
		--disable-scrollkeeper
		--enable-tests
		$(use_enable clutter)
		$(use_enable packagekit)
		$(use_enable raw exiv)"
}

src_prepare() {
	# argyllcms executables are prefixed with "argyll-" in Gentoo; bug #407319
	epatch "${FILESDIR}/${PN}-3.2.2-argyll-prefix.patch"

	gnome2_src_prepare
}

pkg_postinst() {
	gnome2_pkg_postinst

	elog "If you want to do display or scanner calibration, you will need to"
	elog "install media-gfx/argyllcms"
}
