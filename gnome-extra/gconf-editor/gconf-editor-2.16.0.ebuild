# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gconf-editor/gconf-editor-2.16.0.ebuild,v 1.5 2006/12/18 15:28:33 gustavoz Exp $

inherit gnome2

DESCRIPTION="An editor to the GNOME 2 config system"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ~ppc64 sparc x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.6
		 >=gnome-base/gconf-2.10
		 >=gnome-base/libgnome-2.14
		 >=gnome-base/libgnomeui-2.6"

DEPEND="${RDEPEND}
		sys-devel/gettext
		app-text/gnome-doc-utils
		>=dev-util/intltool-0.35
		>=dev-util/pkgconfig-0.19"

DOCS="AUTHORS ChangeLog NEWS README"
