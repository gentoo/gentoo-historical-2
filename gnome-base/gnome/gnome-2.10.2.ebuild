# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome/gnome-2.10.2.ebuild,v 1.1 2005/07/26 23:42:09 leonardop Exp $

DESCRIPTION="Meta package for the GNOME desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="as-is"
SLOT="2.0"
# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~x86 ~ppc ~amd64 ~sparc"
IUSE="accessibility cdr dvdr hal"

S=${WORKDIR}

RDEPEND="!gnome-base/gnome-core

	>=dev-libs/glib-2.6.5
	>=dev-libs/atk-1.9.1
	>=x11-libs/gtk+-2.6.8
	>=x11-libs/pango-1.8.1

	>=dev-libs/libxml2-2.6.19
	>=dev-libs/libxslt-1.1.14

	>=media-libs/audiofile-0.2.6-r1
	>=media-sound/esound-0.2.36
	>=x11-libs/libxklavier-2
	>=gnome-base/gnome-mime-data-2.4.2
	>=media-libs/libart_lgpl-2.3.17

	>=dev-libs/libIDL-0.8.5
	>=gnome-base/orbit-2.12.2

	>=gnome-base/gconf-2.10.1
	>=gnome-base/gnome-keyring-0.4.3
	>=gnome-base/gnome-vfs-2.10.1

	>=gnome-base/libbonobo-2.10
	>=gnome-base/libbonoboui-2.10
	>=gnome-base/libgnome-2.10.1
	>=gnome-base/libgnomeui-2.10.1
	>=gnome-base/libgnomecanvas-2.10.2
	>=gnome-base/libglade-2.5.1

	>=gnome-extra/bug-buddy-2.10
	>=gnome-base/control-center-2.10.2

	>=gnome-base/eel-2.10.1
	>=gnome-base/nautilus-2.10.1

	>=media-libs/gstreamer-0.8.10
	>=media-libs/gst-plugins-0.8.10
	>=gnome-extra/gnome-media-2.10.2
	>=media-video/totem-1.0.4
	>=media-sound/sound-juicer-2.10.1

	>=media-gfx/eog-2.10.2
	!mips? ( >=www-client/epiphany-1.6.4 )
	>=app-arch/file-roller-2.10.4
	>=gnome-extra/gcalctool-5.5.42
	>=gnome-extra/gconf-editor-2.10
	>=gnome-base/gdm-2.8.0.1
	>=app-editors/gedit-2.10.3

	>=app-text/ggv-2.8.5
	>=app-text/gpdf-2.10

	>=gnome-base/gnome-session-2.10
	>=gnome-base/gnome-desktop-2.10.2
	>=gnome-base/gnome-applets-2.10.1
	>=gnome-base/gnome-panel-2.10.2
	>=gnome-base/gnome-menus-2.10.2

	>=x11-themes/gnome-icon-theme-2.10.1
	>=x11-themes/gtk-engines-2.6.3
	>=x11-themes/gnome-themes-2.10.2
	>=x11-themes/gnome-backgrounds-2.10.1

	>=x11-terms/gnome-terminal-2.10
	>=gnome-extra/gnome2-user-docs-2.8.1

	>=x11-libs/gtksourceview-1.2
	>=gnome-extra/gucharmap-1.4.3
	>=gnome-base/libgnomeprint-2.10.3
	>=gnome-base/libgnomeprintui-2.10.2

	>=gnome-extra/gnome-utils-2.10.1
	>=gnome-extra/gnome-games-2.10.1

	>=gnome-base/libgtop-2.10.2
	>=gnome-extra/gnome-system-monitor-2.10.1

	>=gnome-base/librsvg-2.9.5
	>=x11-libs/libwnck-2.10.2
	>=x11-wm/metacity-2.10.2

	>=x11-libs/startup-notification-0.8

	>=gnome-extra/yelp-2.10
	>=x11-libs/vte-0.11.13
	>=gnome-extra/zenity-2.10.1
	>=net-analyzer/gnome-netstatus-2.10

	cdr? ( >=gnome-extra/nautilus-cd-burner-2.10.2 )
	dvdr? ( >=gnome-extra/nautilus-cd-burner-2.10.2 )

	hal? ( >=gnome-base/gnome-volume-manager-1.2.2 )

	>=gnome-extra/evolution-data-server-1.2.3
	>=mail-client/evolution-2.2.3
	>=gnome-extra/evolution-webcal-2.2.1
	>=gnome-extra/gal-2.4.3
	=gnome-extra/libgtkhtml-2.6.3

	>=net-misc/vino-2.10

	>=app-admin/gnome-system-tools-1.2

	accessibility? (
		>=gnome-extra/libgail-gnome-1.1.1
		>=gnome-base/gail-1.8.4
		>=gnome-extra/at-spi-1.6.4
		>=app-accessibility/dasher-3.2.15
		>=app-accessibility/gnome-mag-0.12.1
		>=app-accessibility/gnome-speech-0.3.7
		>=app-accessibility/gok-1.0.5
		>=app-accessibility/gnopernicus-0.10.9 )"

# unrelated
# scrollkeeper
# pkgconfig
# intltool
# gtk-doc

pkg_postinst() {

	einfo "Note that to change windowmanager to metacity do: "
	einfo " export WINDOW_MANAGER=\"/usr/bin/metacity\""
	einfo "of course this works for all other window managers as well"
	echo
	einfo "To take full advantage of GNOME's functionality, please start"
	einfo "the File Alteration Monitoring service (famd) before using"
	einfo "GNOME, unless you have a specific reason for not doing so."
	echo
	einfo "To start famd now use:"
	einfo "'/etc/init.d/famd start'"
	echo
	einfo "And please ensure you add it to the default runlevel using:"
	einfo "'rc-update add famd default'"
	echo

}
