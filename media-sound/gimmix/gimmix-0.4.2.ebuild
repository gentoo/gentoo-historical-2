# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gimmix/gimmix-0.4.2.ebuild,v 1.3 2007/11/04 19:49:36 angelos Exp $

DESCRIPTION="a graphical music player daemon (MPD) client written in C using GTK2."
HOMEPAGE="http://gimmix.berlios.de/"
SRC_URI="http://download.berlios.de/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.6
	>=gnome-base/libglade-2.6
	>=media-libs/libmpd-0.12
	>=media-libs/taglib-1.4"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}

pkg_postinst() {
	elog "gimmix-0.4 introduces a new config file format."
	elog "If you're upgrading from an older version please"
	elog "delete your ~/.gimmixrc before running gimmix."
}
