# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/goffice/goffice-0.6.4.ebuild,v 1.10 2009/04/20 21:55:13 eva Exp $

EAPI=2

inherit autotools eutils gnome2 flag-o-matic

DESCRIPTION="A library of document-centric objects and utilities"
HOMEPAGE="http://freshmeat.net/projects/goffice/"

LICENSE="GPL-2"
SLOT="0.6"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="doc gnome"

# Raising glib dep to 2.14 to drop pcre dependency
#cairo support broken and -gtk broken

RDEPEND=">=dev-libs/glib-2.14
	>=gnome-extra/libgsf-1.13.3[gnome?]
	>=dev-libs/libxml2-2.4.12
	>=x11-libs/pango-1.8.1
	>=x11-libs/gtk+-2.6
	>=gnome-base/libglade-2.3.6
	>=media-libs/libart_lgpl-2.3.11
	>=x11-libs/cairo-1.2[svg]
	gnome? (
		>=gnome-base/gconf-2
		>=gnome-base/libgnomeui-2 )"
# libpcre raised for unicode USE flag

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.18
	>=dev-util/intltool-0.35
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1.4 )"

DOCS="AUTHORS BUGS ChangeLog MAINTAINERS NEWS README"

pkg_setup() {
	G2CONF="${G2CONF} $(use_with gnome)"
	filter-flags -ffast-math
}

src_prepare() {
	gnome2_src_prepare

	# Fix doc slotting
	epatch "${FILESDIR}/${PN}-0.6-doc-slot.patch"

	mv "${S}"/docs/reference/html/goffice{,-0.6}.devhelp
	mv "${S}"/docs/reference/html/goffice{,-0.6}.devhelp2
	mv "${S}"/docs/reference/goffice{,-0.6}-docs.sgml
	mv "${S}"/docs/reference/goffice{,-0.6}-overrides.txt
	mv "${S}"/docs/reference/goffice{,-0.6}-sections.txt
	mv "${S}"/docs/reference/goffice{,-0.6}.types

	eautomake
}
