# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/compiz-plugins-main/compiz-plugins-main-0.8.6.ebuild,v 1.1 2010/04/03 04:52:06 jmbsvicetto Exp $

EAPI="2"

inherit eutils gnome2-utils

DESCRIPTION="Compiz Fusion Window Decorator Plugins"
HOMEPAGE="http://www.compiz.org/"
SRC_URI="http://releases.compiz.org/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="gnome"

MY_PV="0.8.4"

RDEPEND="
	>=gnome-base/librsvg-2.14.0
	media-libs/jpeg
	x11-libs/cairo
	>=x11-libs/compiz-bcop-${MY_PV}
	>=x11-wm/compiz-${PV}[gnome?]
"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.19
	>=sys-devel/gettext-0.15
"

src_prepare() {
	use gnome || epatch "${FILESDIR}"/${PN}-no-gconf.patch
}

src_configure() {
	econf $(use_enable gnome schemas) || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
pkg_preinst() {
	use gnome && gnome2_gconf_savelist
}

pkg_postinst() {
	use gnome && gnome2_gconf_install
}
