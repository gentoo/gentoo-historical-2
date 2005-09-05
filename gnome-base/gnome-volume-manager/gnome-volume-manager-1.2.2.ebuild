# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-volume-manager/gnome-volume-manager-1.2.2.ebuild,v 1.8 2005/09/05 21:13:50 cardoe Exp $

inherit gnome2

DESCRIPTION="Daemon that enforces volume-related policies"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ppc ppc64 x86"
IUSE=""

# we just require the latest of the utopia stack to be on the safe side
RDEPEND=">=x11-libs/gtk+-2.6
	=sys-apps/dbus-0.23*
	=sys-apps/hal-0.4*
	>=gnome-base/libglade-2
	>=gnome-base/gconf-2
	>=gnome-base/libgnomeui-2.2"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.27.2"

USE_DESTDIR="1"
DOCS="AUTHORS ChangeLog HACKING NEWS README TODO"

pkg_postinst() {

	gnome2_pkg_postinst

	einfo "To start the gnome-volume-manager daemon you need to configure"
	einfo "it through it's preferences capplet. Also the HAL daemon (hald)"
	einfo "needs to be running or it will shut down."

}
