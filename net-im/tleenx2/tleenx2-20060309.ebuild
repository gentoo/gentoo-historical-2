# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/tleenx2/tleenx2-20060309.ebuild,v 1.3 2008/01/12 21:21:34 spock Exp $

IUSE=""
LICENSE="GPL-2"

MY_P="TleenX2-${PV}"

DESCRIPTION="A client for Polish Tlen.pl instant messenging system."
HOMEPAGE="http://tleenx.sourceforge.net/"
SRC_URI="mirror://sourceforge/tleenx/${MY_P}.tar.gz"
SLOT="0"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/${MY_P}"

RDEPEND="net-libs/libtlen
	>=x11-libs/gtk+-2.0
	x11-libs/libXScrnSaver"

DEPEND="dev-util/pkgconfig
	${RDEPEND}"

src_install() {
	make DESTDIR="${D}" install
	dodoc doc/* AUTHORS BUGS TODO
}
