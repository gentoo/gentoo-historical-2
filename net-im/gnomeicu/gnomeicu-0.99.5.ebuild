# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/gnomeicu/gnomeicu-0.99.5.ebuild,v 1.8 2005/04/25 06:04:31 kloeri Exp $

inherit gnome2

DESCRIPTION="Gnome ICQ Client"
SRC_URI="mirror://sourceforge/gnomeicu/${P}.tar.bz2"
HOMEPAGE="http://gnomeicu.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc ppc alpha amd64"

DEPEND=">=x11-libs/gtk+-2.2.0
	>=dev-libs/libxml2-2.4.23
	>=gnome-base/libgnome-2.0.0
	>=gnome-base/libgnomeui-2.0.0
	>=sys-libs/gdbm-1.8.0
	>=gnome-base/libglade-2.0.0
	>=app-text/scrollkeeper-0.3.5
	>=dev-util/pkgconfig-0.12.0
	>=dev-util/intltool-0.22
	>=gnome-base/gconf-2.0
	sys-devel/gettext
	spell? ( >=app-text/gtkspell-2.0.4 )"

IUSE="spell"

src_unpack () {
	unpack ${A}
	gnome2_omf_fix ${S}/doc/C/Makefile.in ${S}/doc/omf.make ${S}/doc/uk/Makefile.in
}

src_configure() {
	G2CONF=`use_enable spell`
	gnome2_src_compile
}

DOCS="AUTHORS COPYING CREDITS ChangeLog README ABOUT-NLS"
