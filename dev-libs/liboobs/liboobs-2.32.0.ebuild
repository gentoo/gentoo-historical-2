# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/liboobs/liboobs-2.32.0.ebuild,v 1.1 2010/10/29 21:19:49 pacho Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Liboobs is a wrapping library to the System Tools Backends."
HOMEPAGE="http://www.gnome.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE="doc"

# FIXME: check if policykit should be checked in configure ?
RDEPEND=">=dev-libs/glib-2.14
	>=dev-libs/dbus-glib-0.70
	>=app-admin/system-tools-backends-2.10.1"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	doc? ( >=dev-util/gtk-doc-1.9 )"

pkg_setup() {
	G2CONF="${G2CONF} --without-hal --disable-static"
	DOCS="AUTHORS ChangeLog NEWS README"
}
