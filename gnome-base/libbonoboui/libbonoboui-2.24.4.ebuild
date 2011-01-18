# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libbonoboui/libbonoboui-2.24.4.ebuild,v 1.2 2011/01/18 14:16:02 fauli Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit eutils gnome2 virtualx

DESCRIPTION="User Interface part of libbonobo"
HOMEPAGE="http://developer.gnome.org/arch/gnome/componentmodel/bonobo.html"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE="doc"

# GTK+ dep due to bug #126565
RDEPEND=">=gnome-base/libgnomecanvas-1.116
	>=gnome-base/libbonobo-2.22
	>=gnome-base/libgnome-2.13.7
	>=dev-libs/libxml2-2.4.20
	>=gnome-base/gconf-2
	>=x11-libs/gtk+-2.8.12
	>=dev-libs/glib-2.6.0
	>=gnome-base/libglade-1.99.11
	>=dev-libs/popt-1.5"

DEPEND="${RDEPEND}
	x11-apps/xrdb
	sys-devel/gettext
	>=dev-util/pkgconfig-0.20
	>=dev-util/intltool-0.40
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="${G2CONF} --disable-maintainer-mode"
}

src_configure() {
	addpredict "/root/.gnome2_private"

	gnome2_src_configure
}

src_test() {
	addwrite "/root/.gnome2_private"
	Xemake check || die "tests failed"
}
