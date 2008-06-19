# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/lince/lince-0.99.4.ebuild,v 1.2 2008/06/19 14:21:51 coldwind Exp $

EAPI="1"

MY_P="Lince-${PV}"

DESCRIPTION="a light, powerfull and full feature gtkmm bittorrent client"
SRC_URI="mirror://sourceforge/lincetorrent/${MY_P}.tar.gz"
HOMEPAGE="http://lincetorrent.sourceforge.net"

RDEPEND="dev-cpp/gtkmm:2.4
	x11-libs/cairo
	>=net-libs/rb_libtorrent-0.13
	dev-libs/libxml2
	sys-devel/gettext"
DEPEND="${RDEPEND}
	dev-util/intltool"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_install () {
	emake DESTDIR="${D}" install || die
}
