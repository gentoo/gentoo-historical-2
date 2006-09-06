# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gal/gal-1.99.11.ebuild,v 1.15 2006/09/06 05:29:44 kumba Exp $

inherit gnome2 gnome.org libtool eutils

DESCRIPTION="The Gnome Application Libraries"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="2"
KEYWORDS="alpha amd64 arm hppa ia64 ppc sparc x86"
IUSE="doc"

RDEPEND=">=gnome-base/libgnomeprint-2.2.0
	>=gnome-base/libgnomeprintui-2.2.1
	>=gnome-base/libglade-2.0
	>=gnome-base/libgnomeui-2.0
	>=gnome-base/libgnomecanvas-2.2.0.2
	>=dev-libs/libxml2-2.0
	app-text/scrollkeeper"

DEPEND="sys-devel/gettext
	dev-util/pkgconfig
	>=dev-util/intltool-0.29
	doc? ( dev-util/gtk-doc )
	${RDEPEND}"

MAKEOPTS="${MAKEOPTS} -j1"
USE_DESTDIR="1"
ELTCONF="--reverse-deps"

src_unpack() {
	unpack ${A}

	gnome2_omf_fix

	# Remove gtkdoc-fixxref
	cd ${S}; epatch ${FILESDIR}/gal-1.99.3-docfix.patch
}
