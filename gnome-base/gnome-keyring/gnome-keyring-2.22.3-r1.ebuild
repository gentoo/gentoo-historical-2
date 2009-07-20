# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-keyring/gnome-keyring-2.22.3-r1.ebuild,v 1.13 2009/07/20 20:19:53 eva Exp $

inherit gnome2 eutils pam autotools

DESCRIPTION="Password and keyring managing daemon"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE="debug doc hal pam test"

RDEPEND=">=dev-libs/glib-2.8
	 >=x11-libs/gtk+-2.6
	 gnome-base/gconf
	 >=sys-apps/dbus-1.0
	 hal? ( >=sys-apps/hal-0.5.7 )
	 pam? ( virtual/pam )
	 >=dev-libs/libgcrypt-1.2.2
	 >=dev-libs/libtasn1-1"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	dev-util/gtk-doc-am
	doc? ( dev-util/gtk-doc )"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable debug)
		$(use_enable hal)
		$(use_enable test tests)
		$(use_enable pam)
		$(use_with pam pam-dir $(getpam_mod_dir))
		--with-root-certs=/usr/share/ca-certificates/"
}

src_unpack() {
	gnome2_src_unpack

	# Backport from trunk for fixing upstream bug #511285, bug #238098
	epatch "${FILESDIR}/${P}-warnings.patch"

	# Fix configure with recent libtasn1, bug #266554
	epatch "${FILESDIR}/${P}-pkg-libtasn1.patch"

	intltoolize --force --copy --automake || die "inltoolize failed"
	eautoreconf
}
