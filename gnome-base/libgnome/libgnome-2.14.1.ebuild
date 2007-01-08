# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnome/libgnome-2.14.1.ebuild,v 1.14 2007/01/08 00:38:44 leio Exp $

WANT_AUTOCONF=latest
WANT_AUTOMAKE=1.7
inherit autotools gnome2

DESCRIPTION="Essential Gnome Libraries"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 sh sparc x86"
IUSE="doc esd static"

RDEPEND=">=dev-libs/glib-2.8
	>=gnome-base/gconf-2
	>=gnome-base/libbonobo-2.13
	>=gnome-base/gnome-vfs-2.5.3
	>=dev-libs/popt-1.5
	esd? (
		>=media-sound/esound-0.2.26
		>=media-libs/audiofile-0.2.3 )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.28
	>=dev-util/pkgconfig-0.17
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README"


pkg_setup() {
	G2CONF="${G2CONF} --disable-schemas-install \
		$(use_enable static) \
		$(use_enable esd)"
}

src_unpack() {
	gnome2_src_unpack

	cp aclocal.m4 old_macros.m4
	AT_M4DIR="." eautoreconf
}
