# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/tasks/tasks-0.14.ebuild,v 1.2 2009/07/09 21:46:00 eva Exp $

EAPI="2"
GCONF_DEBUG="no"

inherit eutils gnome2

DESCRIPTION="A small, lightweight to-do list for Gnome"
HOMEPAGE="http://pimlico-project.org/tasks.html"
SRC_URI="http://pimlico-project.org/sources/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

# http://bugzilla.openedhand.com/show_bug.cgi?id=1175
# unreleased >=x11-libs/libsexy-0.1.12

RDEPEND=">=gnome-extra/evolution-data-server-1.8
	>=x11-libs/gtk+-2.6
	>=dev-libs/glib-2.14
	>=dev-libs/libunique-1"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9.0
	>=dev-util/intltool-0.33.0
	sys-devel/gettext"

DOCS="AUTHORS ChangeLog INSTALL NEWS README"

pkg_setup() {
	G2CONF="${G2CONF} --with-unique --enable-gtk"
}

src_prepare() {
	# Add missing config.h, bug #277115
	epatch "${FILESDIR}/${P}-configh.patch"
}
