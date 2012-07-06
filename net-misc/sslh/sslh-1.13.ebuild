# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/sslh/sslh-1.13.ebuild,v 1.1 2012/07/06 18:16:19 kensington Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="SSLH lets one accept both HTTPS and SSH connections on the same port"
HOMEPAGE="http://www.rutschle.net/tech/sslh.shtml"
SRC_URI="http://www.rutschle.net/tech/${P}b.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tcpd"

RDEPEND="tcpd? ( sys-apps/tcp-wrappers )
	dev-libs/libconfig"
DEPEND="${RDEPEND}
	dev-lang/perl"

RESTRICT="test"

src_prepare() {
	sed -i \
		-e '/strip sslh/d' \
		-e '/^LIBS=/s:$: $(LDFLAGS):' \
		-e '/^CFLAGS=/d' \
		Makefile || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		USELIBWRAP=$(usev tcpd)
}

src_install() {
	dobin sslh-{fork,select}
	dosym sslh-fork /usr/bin/sslh
	doman sslh.8.gz
	dodoc ChangeLog README

	newinitd "${FILESDIR}"/sslh.init.d-2 sslh
	newconfd "${FILESDIR}"/sslh.conf.d-2 sslh
}
