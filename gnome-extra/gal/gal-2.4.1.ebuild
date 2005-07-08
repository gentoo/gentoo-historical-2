# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gal/gal-2.4.1.ebuild,v 1.10 2005/07/08 02:48:03 vapier Exp $

inherit gnome2 libtool eutils

DESCRIPTION="The Gnome Application Libraries"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="2.4"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE="doc"

RDEPEND=">=x11-libs/gtk+-2.2
	>=gnome-base/libgnomeprint-2.2
	>=gnome-base/libgnomeprintui-2.2.1
	>=gnome-base/libglade-2
	>=gnome-base/libgnomeui-2
	>=gnome-base/libgnomecanvas-2.2.0.2
	>=dev-libs/libxml2-2
	app-text/scrollkeeper"

DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/pkgconfig
	>=dev-util/intltool-0.30
	doc? ( dev-util/gtk-doc )"

MAKEOPTS="${MAKEOPTS} -j1"
USE_DESTDIR="1"
ELTCONF="--reverse-deps"

src_unpack() {

	unpack ${A}
	gnome2_omf_fix

	#GCC 3.4 fix
	cd ${S}
	epatch ${FILESDIR}/gal-2.1.12-gcc34.patch

	ln -s ${S}/docs/gal-decl.txt ${S}/docs/gal-2.4-decl.txt
	ln -s ${S}/docs/gal-sections.txt ${S}/docs/gal-2.4-sections.txt

	#USE=doc build fix
	epatch ${FILESDIR}/gal-1.99.3-docfix.patch

}
