# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/netrik/netrik-1.15.6.ebuild,v 1.2 2008/03/24 13:26:00 coldwind Exp $

DESCRIPTION="A text based web browser with no ssl support."
HOMEPAGE="http://netrik.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="amd64 ~sparc ~x86"
IUSE="nls"

DEPEND=">=sys-libs/ncurses-5.1
	>=sys-libs/zlib-1.1.3
	nls? ( sys-devel/gettext )"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
