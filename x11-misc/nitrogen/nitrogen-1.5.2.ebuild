# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/nitrogen/nitrogen-1.5.2.ebuild,v 1.1 2011/07/19 12:43:09 jer Exp $

EAPI=2

DESCRIPTION="A background browser and setter for X"
HOMEPAGE="http://projects.l3ib.org/nitrogen/"
SRC_URI="http://projects.l3ib.org/${PN}/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls xinerama"

RDEPEND=">=dev-cpp/gtkmm-2.10:2.4
	>=gnome-base/librsvg-2.20:2
	>=x11-libs/gtk+-2.10:2
	xinerama? ( x11-libs/libXinerama )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )
	xinerama? ( x11-proto/xineramaproto )"

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable nls) \
		$(use_enable xinerama)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README || die
}
