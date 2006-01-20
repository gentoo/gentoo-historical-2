# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gconf-editor/gconf-editor-2.12.1.ebuild,v 1.2 2006/01/20 23:03:23 gustavoz Exp $

inherit gnome2

DESCRIPTION="An editor to the GNOME 2 config system"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 sparc ~x86"
IUSE=""

RDEPEND=">=gnome-base/gconf-2.9.2
	>=x11-libs/gtk+-2.5.5
	>=gnome-base/libgnome-1.96
	>=gnome-base/libgnomeui-2.5.4"

DEPEND="${RDEPEND}
	app-text/scrollkeeper
	sys-devel/gettext
	>=dev-util/intltool-0.28
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog NEWS README"
USE_DESTDIR="1"
