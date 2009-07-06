# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/gdl/gdl-2.26.2.ebuild,v 1.2 2009/07/06 09:26:51 aballier Exp $

inherit gnome2

DESCRIPTION="The Gnome Devtool Libraries"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
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
