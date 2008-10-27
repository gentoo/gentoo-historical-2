# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/compiz-fusion-plugins-main/compiz-fusion-plugins-main-0.7.8.ebuild,v 1.1 2008/10/27 01:12:23 jmbsvicetto Exp $

EAPI="2"

inherit eutils

DESCRIPTION="Compiz Fusion Window Decorator Plugins"
HOMEPAGE="http://compiz-fusion.org"
SRC_URI="http://releases.compiz-fusion.org/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome"
RESTRICT="mirror"

RDEPEND="
	>=gnome-base/librsvg-2.14.0
	media-libs/jpeg
	x11-libs/cairo[glitz]
	~x11-libs/compiz-bcop-${PV}
	~x11-wm/compiz-${PV}
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
	econf $(use_enable gnome gconf) || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}

pkg_postinst() {
	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs to #gentoo-desktop-effects"
	einfo "Thank you on behalf of the Gentoo Desktop-Effects team"
}
