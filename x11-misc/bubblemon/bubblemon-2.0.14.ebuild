# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/bubblemon/bubblemon-2.0.14.ebuild,v 1.3 2010/01/10 18:39:54 fauli Exp $

EAPI=2
GCONF_DEBUG=no
inherit gnome2

DESCRIPTION="A fun monitoring applet for your desktop, complete with swimming duck"
HOMEPAGE="http://www.nongnu.org/bubblemon"
SRC_URI="http://download.savannah.gnu.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="nls"

RDEPEND="x11-libs/gtk+:2
	gnome-base/gnome-panel
	gnome-base/libgnomeui
	gnome-base/libgtop"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( dev-util/intltool
		sys-devel/gettext )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog TRANSLATIONS README TODO"
	G2CONF="$(use_enable nls)"
}

src_prepare() {
	gnome2_src_prepare
	# Fix test suite wrt #295753
	echo gnome/GNOME_BubblemonApplet.server.in >> po/POTFILES.skip
	sed -i -e 's:-g -O2 -Wall -Werror:-Wall:' configure || die "sed failed"
}
