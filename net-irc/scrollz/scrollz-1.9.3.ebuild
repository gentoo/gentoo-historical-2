# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/scrollz/scrollz-1.9.3.ebuild,v 1.4 2004/07/17 14:35:21 swegener Exp $

MY_P=ScrollZ-${PV}

DESCRIPTION="Advanced IRC client based on ircII"
SRC_URI="ftp://ftp.scrollz.com/pub/ScrollZ/source/${MY_P}.tar.gz"
HOMEPAGE="http://www.scrollz.com/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ia64 ~amd64 ~ppc"
IUSE="ipv6 socks5 ssl"

DEPEND="virtual/libc
	ssl? ( dev-libs/openssl )"

S=${WORKDIR}/${MY_P}

src_compile() {
	econf \
		--with-default-server=irc.freenode.net \
		`use_enable ipv6` \
		`use_enable socks5` \
		`use_with ssl` \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	einstall \
		sharedir=${D}/usr/share \
		mandir=${D}/usr/share/man/man1 \
		install \
		|| die "einstall failed"
	chmod 644 ${D}/usr/share/man/man1/scrollz.1
	dodoc README.ScrollZ ChangeLog* README* todo
}
