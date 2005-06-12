# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/gnome-cups-manager/gnome-cups-manager-0.30.ebuild,v 1.7 2005/06/12 15:48:50 kloeri Exp $

inherit gnome2 eutils

DESCRIPTION="GNOME CUPS Printer Management Interface"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~hppa ~ia64 ~mips ppc sparc x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2
	>=x11-libs/gtk+-2
	>=gnome-base/libgnome-2
	>=gnome-base/libgnomeui-2.2
	>=gnome-base/libglade-2
	>=gnome-base/libbonobo-2
	>=net-print/libgnomecups-0.2.0
	app-admin/gnomesu"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.29"

src_install() {
	gnome2_src_install
	insinto /usr/share/applications
	doins ${FILESDIR}/${PN}.desktop
}
