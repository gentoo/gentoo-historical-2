# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/qbittorrent/qbittorrent-1.0.0_rc8.ebuild,v 1.1 2007/11/15 16:10:46 armin76 Exp $

inherit eutils qt4 multilib

MY_P="${P/_/}"

DESCRIPTION="BitTorrent client in C++ and Qt."
HOMEPAGE="http://www.qbittorrent.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=net-libs/rb_libtorrent-0.13_pre1724
	$(qt4_min_version 4.2)
	>=dev-lang/python-2.3
	dev-libs/boost
	net-misc/curl
	dev-cpp/commoncpp2"

pkg_setup() {
	# We need boost built with threads
	if ! has_version ">=dev-libs/boost-1.34_pre20061214" && \
		! built_with_use "dev-libs/boost" threads; then
		eerror "${PN} needs dev-libs/boost built with threads USE flag"
		die "dev-libs/boost is built without threads USE flag"
	fi
}

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
