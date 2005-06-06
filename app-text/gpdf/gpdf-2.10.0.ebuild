# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/gpdf/gpdf-2.10.0.ebuild,v 1.5 2005/06/06 13:16:16 foser Exp $

inherit gnome2 eutils

DESCRIPTION="Viewer for Portable Document Format (PDF) files"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~sparc ~ppc64"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.5.4
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

USE_DESTDIR="1"

src_unpack() {

	unpack ${A}

	cd ${S}
	# Fix sec vuln (#69662)
	epatch ${FILESDIR}/${PN}-xpdf_goo_sizet.patch
	# Fix building on amd64 with gcc4
	epatch ${FILESDIR}/${P}-amd64-gcc4.patch
	# Disable the tests, see bug #73882
	sed -i -e "s:test-files::" Makefile.in
}

src_install() {

	# fix #92920 FIXME
	gnome2_src_install scrollkeeper_localstate_dir=${D}/var/lib/scrollkeeper/

}

