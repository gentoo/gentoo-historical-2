# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/zenity/zenity-2.16.2.ebuild,v 1.7 2007/01/08 04:13:03 leio Exp $

WANT_AUTOCONF=latest
WANT_AUTOMAKE=latest
inherit gnome2 eutils autotools

DESCRIPTION="Tool to display dialogs from the commandline and shell scripts"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 sparc x86"
IUSE="libnotify"

RDEPEND=">=x11-libs/gtk+-2.10
	>=dev-libs/glib-2.8
	>=gnome-base/libglade-2
	>=gnome-base/libgnomecanvas-2
	>=dev-lang/perl-5
	libnotify? ( >=x11-libs/libnotify-0.4.1 )"

DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=dev-util/intltool-0.35
	>=sys-devel/gettext-0.14
	>=dev-util/pkgconfig-0.9
	>=app-text/gnome-doc-utils-0.3.2
	>=gnome-base/gnome-common-2.12.0"

DOCS="AUTHORS ChangeLog HACKING NEWS README THANKS TODO"


pkg_setup() {
	G2CONF="${G2CONF} --disable-scrollkeeper $(use_enable libnotify)"
}

src_unpack() {
	gnome2_src_unpack

	epatch ${FILESDIR}/${PN}-2.15.90-libnotify-support.patch
	eautoreconf
}
