# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libssh2/libssh2-0.14.ebuild,v 1.1 2006/11/27 23:57:08 jokey Exp $

inherit eutils

DESCRIPTION="Library implementing the SSH2 protocol"
HOMEPAGE="http://www.libssh2.org/"
SRC_URI="mirror://sourceforge/libssh2/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-libs/openssl
	sys-libs/zlib"
RDEPEND=${DEPEND}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-configure.patch"
	epatch "${FILESDIR}/${P}-banner-wait.patch"
	epatch "${FILESDIR}/${P}-channel-failure.patch"
	epatch "${FILESDIR}/${P}-peer-shutdown.patch"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README
}
