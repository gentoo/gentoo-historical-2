# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/gpdf/gpdf-2.8.3.ebuild,v 1.1 2005/01/29 03:59:30 joem Exp $

inherit gnome2 eutils

DESCRIPTION="Viewer for Portable Document Format (PDF) files"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~sparc ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.3
	>=gnome-base/gconf-2
	>=gnome-base/libgnomeui-2
	>=gnome-base/libbonobo-2.2.1
	>=gnome-base/libbonoboui-2
	>=gnome-base/gnome-vfs-2
	>=gnome-base/libgnomeprint-2.6
	>=gnome-base/libgnomeprintui-2.2
	>=gnome-base/libglade-2"

DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=dev-util/intltool-0.29
	>=dev-util/pkgconfig-0.12.0"

PROVIDE="virtual/pdfviewer"

DOCS="AUTHORS CHANGES ChangeLog NEWS README*"

src_unpack() {

	unpack ${A}

	cd ${S}
	# fix sec vuln (#69662)
	epatch ${FILESDIR}/${PN}-xpdf_goo_sizet.patch
	# disable the tests, see bug #73882
	sed -i -e "s:test-files::" Makefile.in
}
USE_DESTDIR="1"
