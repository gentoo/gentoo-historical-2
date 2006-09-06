# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnome/libgnome-2.14.0.ebuild,v 1.3 2006/09/06 05:05:03 kumba Exp $

inherit eutils gnome2

DESCRIPTION="Essential Gnome Libraries"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="doc esd static"

RDEPEND=">=dev-libs/glib-2.8
	>=gnome-base/gconf-2
	>=gnome-base/libbonobo-2.13
	>=gnome-base/gnome-vfs-2.5.3
	>=dev-libs/popt-1.5
	esd? ( >=media-sound/esound-0.2.26
		>=media-libs/audiofile-0.2.3 )"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.28
	>=dev-util/pkgconfig-0.17
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="${G2CONF}--disable-schemas-install $(use_enable static) $(use_enable esd)"
}

src_unpack() {
	unpack ${A}
	cd ${S}

	# Adding switch to properly enable/disable esound support. See bug #6920.
	epatch ${FILESDIR}/${PN}-2.10.1-esd_switch.patch

	export WANT_AUTOMAKE=1.7
	cp aclocal.m4 old_macros.m4
	aclocal -I . || die "aclocal failed"
	autoconf || die "autoconf failed"
}

