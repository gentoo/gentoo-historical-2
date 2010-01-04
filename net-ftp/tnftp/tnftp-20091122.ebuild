# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/tnftp/tnftp-20091122.ebuild,v 1.1 2010/01/04 21:34:37 swegener Exp $

EAPI="2"

WANT_AUTOMAKE="1.11"

inherit eutils autotools

DESCRIPTION="NetBSD FTP client with several advanced features"
SRC_URI="ftp://ftp.netbsd.org/pub/NetBSD/misc/${PN}/${P}.tar.gz
	ftp://ftp.netbsd.org/pub/NetBSD/misc/${PN}/old/${P}.tar.gz"
HOMEPAGE="ftp://ftp.netbsd.org/pub/NetBSD/misc/tnftp/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE="ipv6 socks5"

DEPEND=">=sys-libs/ncurses-5.1
	socks5? ( net-proxy/dante )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-glibc-2.8-ARG_MAX.patch
	epatch "${FILESDIR}"/${P}-as-needed.patch

	eautoreconf
}

src_configure() {
	econf \
		--enable-editcomplete \
		$(use_enable ipv6) \
		$(use_with socks5 socks) \
		|| die "econf failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc ChangeLog README THANKS || die "dodoc failed"
}
