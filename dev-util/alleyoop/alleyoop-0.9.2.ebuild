# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/alleyoop/alleyoop-0.9.2.ebuild,v 1.5 2007/07/12 01:05:42 mr_bones_ Exp $

inherit gnome2 eutils

DESCRIPTION="A Gtk+ front-end to the Valgrind memory checker for x86 GNU/ Linux."
HOMEPAGE="http://alleyoop.sourceforge.net/"
SRC_URI="mirror://sourceforge/alleyoop/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-alpha ~ppc -sparc x86"
IUSE="doc"

RDEPEND=">=dev-libs/glib-2.2
	>=x11-libs/gtk+-2.2
	>=gnome-base/gconf-2.2
	>=gnome-base/libgnomeui-2.2
	>=gnome-base/libglade-2.2
	sys-devel/binutils
	>=dev-util/valgrind-2.4
	virtual/libc"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README"
