# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gcalctool/gcalctool-5.32.2.ebuild,v 1.6 2011/03/22 19:24:14 ranger Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="A calculator application for GNOME"
HOMEPAGE="http://live.gnome.org/Gcalctool http://calctool.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.18:2
	>=dev-libs/glib-2.25.10:2
	dev-libs/libxml2
	!<gnome-extra/gnome-utils-2.3"
DEPEND="${RDEPEND}
	sys-devel/gettext
	app-text/scrollkeeper
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	>=app-text/gnome-doc-utils-0.3.2"

pkg_setup() {
	G2CONF="${G2CONF}
		--with-gtk=2.0"
	DOCS="AUTHORS ChangeLog* NEWS README"
}
