# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/gdl/gdl-2.24.0.ebuild,v 1.11 2010/04/21 22:14:28 eva Exp $

inherit gnome2

DESCRIPTION="The Gnome Devtool Libraries"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="hppa ppc64"
IUSE="doc"

RDEPEND=">=dev-libs/glib-2
	>=x11-libs/gtk+-2.12
	>=dev-libs/libxml2-2.4
	>=gnome-base/libglade-2.0"
DEPEND="${RDEPEND}
	!<dev-python/gdl-python-2.19.1-r1
	!<=dev-python/gnome-python-extras-2.19.1-r2
	dev-util/pkgconfig
	>=dev-util/intltool-0.35
	doc? ( >=dev-util/gtk-doc-1.4 )"

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"
