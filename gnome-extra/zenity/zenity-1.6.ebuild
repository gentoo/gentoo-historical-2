# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/zenity/zenity-1.6.ebuild,v 1.9 2003/10/18 22:54:00 brad_mssw Exp $

inherit gnome2

DESCRIPTION="commandline dialog tool for gnome"
HOMEPAGE="http://www.gnome.org/"
LICENSE="LGPL-2"

SLOT="0"
KEYWORDS="x86 ~ppc alpha ~sparc amd64"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2
	>=gnome-base/libglade-2
	>=gnome-base/gconf-2
	>=gnome-base/libgnomecanvas-2
	dev-libs/popt"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.21
	app-text/scrollkeeper
	dev-util/pkgconfig"

DOCS="AUTHORS COPYING ChangeLog HACKING INSTALL NEWS README THANKS TODO"

src_compile() {
	gnome2_src_configure "$@"
	# Fix bug which breaks compilation with some CFLAGS and compiler
	# combinations.  See bug 28664 for more information
	echo '#include <locale.h>' >> config.h
	emake || die "compile failure"
}
