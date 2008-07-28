# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/contacts/contacts-0.9.ebuild,v 1.1 2008/07/28 22:57:35 eva Exp $

inherit gnome2

DESCRIPTION="A small, lightweight addressbook for GNOME"
HOMEPAGE="http://pimlico-project.org/contacts.html"
SRC_URI="http://pimlico-project.org/sources/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="dbus"

RDEPEND=">=gnome-extra/evolution-data-server-1.8
		>=x11-libs/gtk+-2.6"
DEPEND="${RDEPEND}
		sys-devel/gettext
		>=dev-util/intltool-0.35.0
		>=dev-util/pkgconfig-0.9"

pkg_setup() {
	G2CONF="$(use_enable dbus)"
}
