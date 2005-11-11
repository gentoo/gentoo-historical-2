# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/socat/socat-1.4.2.0-r1.ebuild,v 1.6 2005/11/11 23:15:26 hansmi Exp $

DESCRIPTION="Multipurpose relay (SOcket CAT)"
HOMEPAGE="http://www.dest-unreach.org/socat/"
SRC_URI="http://www.dest-unreach.org/${PN}/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~hppa ia64 ~mips ppc sparc x86"
IUSE="ssl readline ipv6 tcpd"

DEPEND="ssl? ( >=dev-libs/openssl-0.9.6 )
	readline? ( >=sys-libs/ncurses-5.1 >=sys-libs/readline-4.1 )
	tcpd? ( sys-apps/tcp-wrappers )
	virtual/libc"

S=${WORKDIR}/socat-${PV:0:3}

src_compile() {
	econf \
		$(use_enable ssl openssl) \
		$(use_enable readline) \
		$(use_enable ipv6 ip6) \
		$(use_enable tcpd libwrap) \
		|| die "econf failed"
	emake || die
}

src_install() {
	dodir /usr/bin /usr/share/man/man1
	make install DESTDIR="${D}" || die

	dodoc BUGREPORTS CHANGES DEVELOPMENT EXAMPLES \
		FAQ FILES PORTING README SECURITY VERSION xio.help
	docinto examples
	dodoc *.sh
	dohtml socat.html
}
