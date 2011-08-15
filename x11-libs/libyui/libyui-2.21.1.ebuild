# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libyui/libyui-2.21.1.ebuild,v 1.1 2011/08/15 09:27:51 miska Exp $

EAPI=4

inherit autotools

DESCRIPTION="UI abstraction library"
HOMEPAGE="http://sourceforge.net/projects/libyui/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt4 ncurses gtk"

DEPEND=""
REQUIRED_USE="|| ( qt4 ncurses gtk )"
PDEPEND="
	qt4? ( x11-libs/libyui-qt )
	ncurses? ( x11-libs/libyui-ncurses )
	gtk? ( x11-libs/libyui-gtk )
	"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f {} +
}
