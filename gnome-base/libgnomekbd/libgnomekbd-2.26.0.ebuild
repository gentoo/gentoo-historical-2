# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnomekbd/libgnomekbd-2.26.0.ebuild,v 1.12 2010/07/20 02:09:17 jer Exp $

EAPI="2"
GCONF_DEBUG="no"

inherit autotools eutils gnome2

DESCRIPTION="Gnome keyboard configuration library"
HOMEPAGE="http://www.gnome.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-libs/glib-2.16
	>=sys-apps/dbus-0.92
	>=dev-libs/dbus-glib-0.34
	>=gnome-base/gconf-2.14
	>=x11-libs/gtk+-2.13
	>=gnome-base/libglade-2.6
	>=x11-libs/libxklavier-3.2"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.19"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	# Only user interaction required graphical tests at the time of 2.22.0 - not useful for us
	G2CONF="${G2CONF} --disable-tests --disable-static"
}

src_prepare() {
	# Fix linking to system's library, bug #265428
	epatch "${FILESDIR}/${PN}-2.22.0-system-relink.patch"

	# Fix silly upstream CFLAGS, bug #277291
	sed "s/-Werror//g" -i capplet/Makefile.am capplet/Makefile.in \
		libgnomekbd/Makefile.am libgnomekbd/Makefile.in \
		test/Makefile.am test/Makefile.in \
		configure.in configure || die "removing -Werror failed"

	# Fix libxklavier-4 API changes, bug #278367
	epatch "${FILESDIR}/${PN}-2.26.0-libxklavier4.patch"

	# Make it libtool-1 compatible
	rm -v m4/lt* m4/libtool.m4 || die "removing libtool macros failed"

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf
}

src_compile() {
	# FreeBSD doesn't like -j
	use x86-fbsd && MAKEOPTS="${MAKEOPTS} -j1"
	gnome2_src_compile
}
