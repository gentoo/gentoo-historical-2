# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/gobby/gobby-0.4.93.ebuild,v 1.2 2010/06/18 10:52:45 xarthisius Exp $

EAPI=2

inherit eutils gnome2

DESCRIPTION="GTK-based collaborative editor"
HOMEPAGE="http://gobby.0x539.de/"
SRC_URI="http://releases.0x539.de/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0.5"
KEYWORDS="~amd64 ~x86"
IUSE="avahi doc nls"

RDEPEND="dev-cpp/glibmm:2
	dev-cpp/gtkmm:2.4
	dev-libs/libsigc++:2
	>=net-libs/libinfinity-0.4[gtk,avahi?]
	dev-cpp/libxmlpp:2.6
	x11-libs/gtksourceview:2.0
	nls? ( >=sys-devel/gettext-0.12.1 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? (
		app-text/gnome-doc-utils
		app-text/scrollkeeper
		)"

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die
	domenu contrib/gobby-0.5.desktop
	doicon gobby-0.5.xpm
}
