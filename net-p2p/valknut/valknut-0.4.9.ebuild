# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/valknut/valknut-0.4.9.ebuild,v 1.5 2010/01/10 18:44:51 nixnut Exp $

EAPI=2

DESCRIPTION="A open source cross platform client for the Direct Connect network"
HOMEPAGE="http://sourceforge.net/projects/wxdcgui/"
SRC_URI="mirror://sourceforge/wxdcgui/${P}.tar.bz2
	gnome? ( mirror://sourceforge/wxdcgui/${P}-gnome-icons.tar.gz )
	kde? ( mirror://sourceforge/wxdcgui/${P}-oxygen-icons.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 x86"
IUSE="gnome kde"

RDEPEND="x11-libs/qt-gui:4[qt3support]
	>=net-p2p/dclib-0.3.23"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	econf \
		--disable-dependency-tracking
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO

	insinto /usr/share/${PN}/icons/appl

	if use gnome; then
		doins -r "${WORKDIR}"/${P}-gnome-icons/gnome
	fi

	if use kde; then
		doins -r "${WORKDIR}"/${P}-oxygen-icons/oxygen
	fi
}
