# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/vala/vala-0.7.10.ebuild,v 1.4 2010/05/19 17:44:04 halcy0n Exp $

EAPI=1
GCONF_DEBUG=no
inherit gnome2

DESCRIPTION="Vala - Compiler for the GObject type system"
HOMEPAGE="http://live.gnome.org/Vala"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"
IUSE="test +vapigen +coverage"

RDEPEND=">=dev-libs/glib-2.12"
DEPEND="${RDEPEND}
	sys-devel/flex
	|| ( sys-devel/bison dev-util/byacc dev-util/yacc )
	dev-util/pkgconfig
	dev-libs/libxslt
	test? ( dev-libs/dbus-glib )"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable vapigen)
		$(use_enable coverage)"
	DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"
}
