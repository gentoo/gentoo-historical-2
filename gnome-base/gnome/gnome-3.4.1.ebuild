# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome/gnome-3.4.1.ebuild,v 1.2 2012/09/10 06:23:33 tetromino Exp $

EAPI="4"

DESCRIPTION="Meta package for GNOME 3, merge this package to install"
HOMEPAGE="http://www.gnome.org/"

LICENSE="as-is"
SLOT="2.0" # Cannot be installed at the same time as gnome-2

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~amd64 ~x86"

IUSE="accessibility +bluetooth +cdr cups +extras +fallback"

S=${WORKDIR}

# TODO: check accessibility completeness
# GDM-3.0 integrates very nicely with GNOME Shell
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}[cups?]
	>=gnome-base/gnome-core-apps-${PV}[cups?,bluetooth?,cdr?]

	>=gnome-base/gdm-${PV}

	>=x11-wm/mutter-${PV}
	>=gnome-base/gnome-shell-${PV}[bluetooth?]

	>=x11-themes/gnome-backgrounds-${PV}
	>=x11-themes/gnome-icon-theme-extras-3.4
	x11-themes/sound-theme-freedesktop

	accessibility? (
		>=app-accessibility/at-spi2-atk-2.4
		>=app-accessibility/at-spi2-core-2.4.1
		>=app-accessibility/caribou-0.4.2
		>=app-accessibility/orca-${PV}
		>=gnome-extra/mousetweaks-${PV} )
	extras? ( >=gnome-base/gnome-extra-apps-${PV} )
	fallback? (
		>=gnome-base/gnome-applets-${PV}
		>=gnome-base/gnome-fallback-${PV} )"
DEPEND=""
PDEPEND="|| ( >=gnome-base/gvfs-1.12.1[udisks] >=gnome-base/gvfs-1.12.1[gdu] )"
# Broken from assumptions of gnome-vfs headers being included in nautilus headers,
# which isn't the case with nautilus-2.22, bug #216019
#	>=app-admin/gnome-system-tools-2.32.0
#	>=app-admin/system-tools-backends-2.8

# gnome-cups-manager isn't needed, printing support is in gnome-control-center

# Not ported:
#   bug-buddy-2.32
#   sound-juicer-2.32
#
# Not ported, don't build:
#	gnome-extra/evolution-webcal-2.32.0

# These don't work with gsettings/dconf
#	>=app-admin/pessulus-2.30.4
#	ldap? (	>=app-admin/sabayon-2.30.1 )

# I'm not sure what all is in a11y for GNOME 3 yet ~nirbheek
#	accessibility? (
#		>=gnome-extra/libgail-gnome-1.20.3
#		>=gnome-extra/at-spi-1.32.0:1
#		>=app-accessibility/dasher-4.11
#		>=app-accessibility/gnome-mag-0.16.3:1
#		>=app-accessibility/gnome-speech-0.4.25:1
#		>=app-accessibility/gok-2.30.1:1
#		>=app-accessibility/orca-2.32.1
#		>=gnome-extra/mousetweaks-2.32.1 )

# Useless with GNOME Shell
#	>=gnome-extra/deskbar-applet-2.32.0
#	>=gnome-extra/hamster-applet-2.32.1

# Development tools
#   scrollkeeper
#   pkgconfig
#   intltool
#   gtk-doc
#   gnome-doc-utils
#   itstool
#   yelp-tools

#pkg_postinst() {
# gnome-wm is gone, session files are now used by gnome-session to decide which
# windowmanager etc to use. Need to document this
#
# FIXME: Is this still relevant?
#
#	elog "The main file alteration monitoring functionality is"
#	elog "provided by >=glib-2.16. Note that on a modern Linux system"
#	elog "you do not need the USE=fam flag on it if you have inotify"
#	elog "support in your linux kernel ( >=2.6.13 ) enabled."
#	elog "USE=fam on glib is however useful for other situations,"
#	elog "such as Gentoo/FreeBSD systems. A global USE=fam can also"
#	elog "be useful for other packages that do not use the new file"
#	elog "monitoring API yet that the new glib provides."
#	elog
#}
