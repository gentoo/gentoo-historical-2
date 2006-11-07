# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-power-manager/gnome-power-manager-2.14.3-r1.ebuild,v 1.2 2006/11/07 17:38:51 dang Exp $

GNOME_TARBALL_SUFFIX="gz"

inherit gnome2 eutils

DESCRIPTION="Gnome Power Manager"
HOMEPAGE="http://gnome-power.sf.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc libnotify"

RDEPEND=">=dev-libs/glib-2.6.0
		 >=x11-libs/gtk+-2.6.0
		 >=gnome-base/libgnome-2.10.0
		 >=gnome-base/libgnomeui-2.10.0
		 >=sys-apps/dbus-0.61
		 >=sys-apps/hal-0.5.7-r1
		 >=gnome-base/libglade-2.5.0
		 >=x11-libs/libwnck-2.10.0
		 libnotify?	(
						>=x11-libs/libnotify-0.2.2
						>=x11-misc/notification-daemon-0.2.1
					)
		 || (
				(
					x11-libs/libX11
					x11-libs/libXext
				)
				virtual/x11
			)
		 sys-devel/gettext"
DEPEND="${RDEPEND}
		dev-util/pkgconfig
		app-text/xmlto
		app-text/gnome-doc-utils
		>=dev-util/intltool-0.27.2
		doc? ( app-text/docbook-sgml-utils )"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF} $(use_enable libnotify) --enable-actions-menu --with-dpms-ext"
}
