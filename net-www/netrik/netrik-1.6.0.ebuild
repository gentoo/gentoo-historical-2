# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/netrik/netrik-1.6.0.ebuild,v 1.8 2005/02/23 15:24:47 sekretarz Exp $

DESCRIPTION="A text based web browser with no ssl support."
HOMEPAGE="http://netrik.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="x86"
IUSE="nls"

DEPEND=">=sys-libs/ncurses-5.1
	>=sys-libs/zlib-1.1.3
	nls? ( sys-devel/gettext )"

src_compile() {
	econf || die
	emake || die "Compile problem"
}

src_install() {
	make \
		prefix=${D}/usr \
		datadir=${D}/usr/share \
		mandir=${D}/usr/share/man \
		libdir=${D} install \
		|| die "Unablr to do install"
}
