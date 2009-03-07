# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/qbittorrent/qbittorrent-1.0.0.ebuild,v 1.6 2009/03/07 16:13:27 betelgeuse Exp $

EAPI="1"

inherit eutils qt4 multilib

MY_P="${P/_/}"

DESCRIPTION="BitTorrent client in C++ and Qt."
HOMEPAGE="http://www.qbittorrent.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

# boost version so that we always have threads support
DEPEND="|| ( x11-libs/qt-gui:4 =x11-libs/qt-4.3*:4 )
	>=net-libs/rb_libtorrent-0.13
	>=dev-libs/boost-1.34.1
	net-misc/curl
	dev-cpp/commoncpp2"
RDEPEND="${DEPEND}
	>=dev-lang/python-2.3"

src_compile() {
	# econf fails, since this uses qconf
	./configure --prefix=/usr --qtdir=/usr \
		--with-libtorrent-inc=/usr/include \
		--with-libtorrent-lib=/usr/$(get_libdir) \
		|| die "configure failed"
	emake || die "emake failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	dodoc AUTHORS Changelog NEWS README TODO
}
