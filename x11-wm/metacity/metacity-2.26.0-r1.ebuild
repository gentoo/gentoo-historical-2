# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/metacity/metacity-2.26.0-r1.ebuild,v 1.8 2010/01/14 01:03:19 jer Exp $

EAPI="2"

inherit eutils gnome2

DESCRIPTION="GNOME default window manager"
HOMEPAGE="http://blogs.gnome.org/metacity/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd"
IUSE="test xinerama"

RDEPEND=">=x11-libs/gtk+-2.10
	>=x11-libs/pango-1.2[X]
	>=gnome-base/gconf-2
	>=dev-libs/glib-2.6
	>=x11-libs/startup-notification-0.7
	>=x11-libs/libXcomposite-0.2
	x11-libs/libXfixes
	x11-libs/libXrender
	x11-libs/libXdamage
	x11-libs/libXcursor
	x11-libs/libX11
	xinerama? ( x11-libs/libXinerama )
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libSM
	x11-libs/libICE
	gnome-extra/zenity
	!x11-misc/expocity"
DEPEND="${RDEPEND}
	>=app-text/gnome-doc-utils-0.8
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	test? ( app-text/docbook-xml-dtd:4.5 )
	xinerama? ( x11-proto/xineramaproto )
	x11-proto/xextproto
	x11-proto/xproto"

DOCS="AUTHORS ChangeLog HACKING NEWS README *.txt doc/*.txt"

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-compositor
		--enable-gconf
		--enable-render
		--enable-shape
		--enable-sm
		--enable-startup-notification
		--enable-xsync
		$(use_enable xinerama)"
}

src_prepare() {
	gnome2_src_prepare

	# Remove stupid CFLAGS, bug #259179
	sed "s:-Werror::g" -i configure.in configure || die "sed failed"

	# Fix behavior wrt. panel overlap, bug #268699
	epatch "${FILESDIR}/${P}-panel-behavior.patch"
}
