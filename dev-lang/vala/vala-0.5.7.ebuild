# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/vala/vala-0.5.7.ebuild,v 1.3 2009/07/16 20:55:04 ssuominen Exp $

EAPI="1"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Vala - Compiler for the GObject type system"
HOMEPAGE="http://live.gnome.org/Vala"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~arm ~amd64 ~ppc ~x86"
IUSE="+vapigen"

RDEPEND=">=dev-libs/glib-2.12.0"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	dev-libs/libxslt"

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"

pkg_setup() {
	G2CONF="${G2CONF} $(use_enable vapigen)"
}
