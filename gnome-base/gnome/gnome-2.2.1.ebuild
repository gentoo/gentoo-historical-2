# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome/gnome-2.2.1.ebuild,v 1.8 2003/09/06 23:51:37 msterret Exp $

S=${WORKDIR}
DESCRIPTION="Meta package for the GNOME desktop, merge this package to install"
HOMEPAGE="http://www.gnome.org/"
LICENSE="as-is"
SLOT="2.0"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="x86 ppc ~alpha sparc hppa amd64"

#  Note to developers:
#  This is a wrapper for the complete Gnome2 desktop,
#  This means all components that a user expects in Gnome2 are present
#  please do not reduce this list further unless
#  dependencies pull in what you remove.
#  With "emerge gnome" a user expects the full "standard" distribution of Gnome and should be provided with that, consider only installing the parts needed for smaller installations.

# Metacity was choosen as the default window manager because of sawfish's long time of non-working state.

# eog is installed to provide with image previews in nautilus.

# gedit is a core example of Gnome2 platform

# applets will pull in the gnome-panel

# after the blank line are the "complete" list we use for gnome2 betas

# after the second blank line added packages for gnome2.1+

RDEPEND="!gnome-base/gnome-core
	>=x11-wm/metacity-2.4.34
	>=gnome-base/gnome-session-2.2.1
	>=gnome-extra/bug-buddy-2.2.103
	>=gnome-base/gdm-2.4.1.3
	>=media-gfx/eog-2.2.1
	>=app-editors/gedit-2.2.1
	>=gnome-extra/yelp-2.2
	>=gnome-base/nautilus-2.2.2
	>=x11-terms/gnome-terminal-2.2.1
	>=gnome-base/gnome-applets-2.2.1
	>=gnome-base/control-center-2.2.1
	>=gnome-extra/gnome-utils-2.2.1
	>=gnome-extra/gnome-system-monitor-2.0.4
	>=gnome-extra/gnome-games-2.2
	>=gnome-extra/gconf-editor-0.4.0
	>=gnome-extra/gnome2-user-docs-2.0.6
	>=gnome-base/gnome-mime-data-2.2.0

	>=x11-libs/gtk+-2.2.1
	>=x11-libs/pango-1.2.1
	>=dev-libs/atk-1.2.2
	>=dev-libs/glib-2.2.1
	>=gnome-base/gconf-2.2
	>=gnome-base/gnome-panel-2.2.1
	>=gnome-base/gnome-desktop-2.2.1
	>=gnome-base/gnome-vfs-2.2.3
	>=gnome-base/libbonobo-2.2.1
	>=gnome-base/libbonoboui-2.2.0.1
	>=gnome-base/librsvg-2.2.4
	>=gnome-base/libgnome-2.2.0.1
	>=gnome-base/libgnomecanvas-2.2.0.2
	>=gnome-base/libgnomeui-2.2.0.1
	>=gnome-base/bonobo-activation-2.2.1.1
	>=net-libs/linc-1.0.1
	>=gnome-base/libglade-2.0.1
	>=x11-libs/libwnck-2.2.1
	>=gnome-base/ORBit2-2.6.1
	>=gnome-base/libgnomeprint-2.2.1.2
	>=gnome-base/libgnomeprintui-2.2.1.2
	>=gnome-extra/libgail-gnome-1.0.2
	>=x11-themes/gnome-icon-theme-1.0.1
	>=x11-themes/gnome-themes-2.2.1

	>=app-arch/file-roller-2.2.2
	>=gnome-extra/acme-2.0.2
	>=app-text/ggv-1.99.98

	!hppa? ( !alpha? (
		>=gnome-extra/gnome-media-2.2.1.1
		>=gnome-extra/nautilus-media-0.2.1
		>=media-libs/gst-plugins-0.6.0-r1
		>=media-libs/gstreamer-0.6.0-r2 ) )"

# The packages marked !alpha above don't build yet on alpha.  We
# haven't given up, but there's no reason for them to hold up Gnome
# 2.2 for alpha.

pkg_postinst () {
	einfo "note that to change windowmanager to metacity do: "
	einfo " export WINDOW_MANAGER=\"/usr/bin/metacity\""
	einfo "of course this works for all other window managers as well"
}
