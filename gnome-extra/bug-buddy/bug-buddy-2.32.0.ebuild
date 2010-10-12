# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/bug-buddy/bug-buddy-2.32.0.ebuild,v 1.1 2010/10/12 19:13:33 pacho Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="A graphical bug reporting tool"
HOMEPAGE="http://www.gnome.org/"

LICENSE="Ximian-logos GPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="eds"

RDEPEND=">=gnome-base/libbonobo-2
	>=dev-libs/glib-2.16:2
	>=dev-libs/libxml2-2.4.6
	>=x11-libs/gtk+-2.14:2
	>=net-libs/libsoup-2.4
	>=gnome-base/libgtop-2.13.3
	>=gnome-base/gconf-2
	|| ( dev-libs/elfutils dev-libs/libelf )
	>=sys-devel/gdb-5.1
	eds? ( >=gnome-extra/evolution-data-server-1.3 )"
DEPEND="${RDEPEND}
	>=app-text/gnome-doc-utils-0.3.2
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable eds)"
	DOCS="AUTHORS ChangeLog NEWS README TODO"
}
