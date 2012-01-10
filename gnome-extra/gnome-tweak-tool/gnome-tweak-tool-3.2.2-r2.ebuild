# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-tweak-tool/gnome-tweak-tool-3.2.2-r2.ebuild,v 1.1 2012/01/10 17:38:32 tetromino Exp $

EAPI="4"
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="no"
PYTHON_DEPEND="2:2.6"

inherit eutils gnome2 python

DESCRIPTION="Tool to customize GNOME 3 options"
HOMEPAGE="http://live.gnome.org/GnomeTweakTool"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="
	>=gnome-base/gsettings-desktop-schemas-3
	>=dev-python/pygobject-2.90.0:3
	gnome-base/gconf:2"
# g-s-d, gnome-shell etc. needed at runtime for the gsettings schemas
RDEPEND="${COMMON_DEPEND}
	gnome-base/gconf:2[introspection]
	x11-libs/gtk+:3[introspection]

	>=gnome-base/gnome-settings-daemon-3
	gnome-base/gnome-shell
	>=gnome-base/nautilus-3
	x11-wm/metacity"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40.0
	>=dev-util/pkgconfig-0.9
	>=sys-devel/gettext-0.17"

pkg_setup() {
	DOCS="AUTHORS NEWS README"
	G2CONF="${G2CONF} --disable-schemas-compile"
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	# Add contents of Gentoo's cursor theme directory to cursor theme list
	epatch "${FILESDIR}/${PN}-3.0.4-gentoo-cursor-themes.patch"

	# Patch from upstream git master; user theme extension ID changed in 3.2.2
	epatch "${FILESDIR}/${PN}-3.2.2-user-theme-ext-id.patch"

	# From upstream git master; fix gnome-shell-3.2.1-r2 compat (bug #398385)
	epatch "${FILESDIR}/${PN}-3.2.2-gnome-shell-3.2.1-r2.patch"

	# From upstream git master; more useful error on missing schemas
	epatch "${FILESDIR}/${PN}-3.2.2-missing-schemas-error.patch"

	# disable pyc compiling
	echo > py-compile

	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	python_convert_shebangs 2 "${ED}"/usr/bin/gnome-tweak-tool
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_mod_optimize gtweak
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup gtweak
}
