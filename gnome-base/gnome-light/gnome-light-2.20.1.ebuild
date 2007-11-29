# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-light/gnome-light-2.20.1.ebuild,v 1.8 2007/11/29 06:22:19 jer Exp $

S=${WORKDIR}
DESCRIPTION="Meta package for the GNOME desktop, merge this package to install"
HOMEPAGE="http://www.gnome.org/"
LICENSE="as-is"
SLOT="2.0"
IUSE=""

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"

#  Note to developers:
#  This is a wrapper for the 'light' Gnome2 desktop,
#  This should only consist of the bare minimum of libs/apps needed
#  It is basicly the gnome-base/gnome without all extra apps

#  This is currently in it's test phase, if you feel like some dep
#  should be added or removed from this pack file a bug to
#  gnome@gentoo.org on bugs.gentoo.org

#	>=media-gfx/eog-2.2.1

RDEPEND="!gnome-base/gnome

	>=dev-libs/glib-2.14.2
	>=x11-libs/gtk+-2.12.1
	>=dev-libs/atk-1.20.0
	>=x11-libs/pango-1.18.3

	>=gnome-base/orbit-2.14.10

	>=x11-libs/libwnck-2.20.1
	>=x11-wm/metacity-2.20.0

	>=gnome-base/gnome-vfs-2.20.0
	>=gnome-base/gconf-2.20.1

	>=gnome-base/gnome-mime-data-2.18.0

	>=gnome-base/libbonobo-2.20.1
	>=gnome-base/libbonoboui-2.20.0
	>=gnome-base/libgnome-2.20.1.1
	>=gnome-base/libgnomeui-2.20.1
	>=gnome-base/libgnomecanvas-2.20.1
	>=gnome-base/libglade-2.6.2

	>=gnome-base/control-center-2.20.1

	>=gnome-base/eel-2.20.0
	>=gnome-base/nautilus-2.20.0

	>=gnome-base/gnome-desktop-2.20.1
	>=gnome-base/gnome-session-2.20.1
	>=gnome-base/gnome-panel-2.20.1

	>=x11-themes/gnome-icon-theme-2.20.0
	>=x11-themes/gnome-themes-2.20.1

	>=x11-terms/gnome-terminal-2.18.2

	>=gnome-base/librsvg-2.18.2

	>=gnome-extra/yelp-2.20.0"

pkg_postinst () {

	elog "Note that to change windowmanager to metacity do: "
	elog " export WINDOW_MANAGER=\"/usr/bin/metacity\""
	elog "of course this works for all other window managers as well"
	elog
	elog "Use gnome-base/gnome for the full GNOME Desktop"
	elog "as released by the GNOME team."

}
