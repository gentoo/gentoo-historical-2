# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gtksourceview/gtksourceview-1.1.1.ebuild,v 1.3 2004/12/19 14:57:01 kloeri Exp $

inherit gnome2

DESCRIPTION="GTK text widget with syntax highlighting and other features typical for a source editor"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="x86 ppc alpha ~sparc ~hppa ~amd64 ~ia64 ~mips ~ppc64"
IUSE="doc"

RDEPEND=">=x11-libs/gtk+-2.2.4
	>=dev-libs/libxml2-2.5
	>=gnome-base/libgnomeprint-2.8"

DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.30
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1 )"

# Removes the gnome-vfs dep
G2CONF="${G2CONF} --disable-build-tests"

DOCS="AUTHORS ChangeLog HACKING MAINTAINERS NEWS README TODO"
