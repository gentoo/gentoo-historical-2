# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/scrollz/scrollz-1.9.ebuild,v 1.6 2004/05/29 16:16:27 pvdabeel Exp $

DESCRIPTION="Advanced IRC client based on ircII"
SRC_URI="ftp://ftp.scrollz.com/pub/ScrollZ/source/ScrollZ-${PV}.tar.gz"
HOMEPAGE="http://www.scrollz.com/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ia64 amd64 ~ppc"
IUSE="ipv6 socks5 ssl"

DEPEND="virtual/glibc
	ssl? ( dev-libs/openssl )"

S=${WORKDIR}/ScrollZ-${PV}

src_compile() {
	econf \
		--with-default-server=localhost \
		`use_enable ipv6` \
		`use_enable socks5` \
		`use_with ssl` \
		|| die
	emake || die
}

src_install() {
	einstall sharedir=${D}/usr/share install || die
	dodoc README.ScrollZ ChangeLog* README* todo
}
