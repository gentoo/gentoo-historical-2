# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/sms/sms-2.0.2.ebuild,v 1.3 2005/01/16 04:55:54 dragonheart Exp $

inherit toolchain-funcs

DESCRIPTION="Command line program for sending SMS to Polish GSM mobile phone users"
HOMEPAGE="http://ceti.pl/~miki/komputery/sms.html"
SRC_URI="http://ceti.pl/~miki/komputery/download/sms/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""
RDEPEND="virtual/libc
	sys-libs/gdbm
	dev-libs/libpcre
	dev-libs/pcre++
	net-misc/curl"

DEPEND="${RDEPEND}
	sys-devel/gcc
	sys-apps/sed"

src_compile() {
	emake CXX=$(tc-getCXX) CXXFLAGS="${CXXFLAGS} -I./lib" LDFLAGS="-lc" || die
}

src_install() {
	dobin sms smsaddr
	dodoc README README.smsrc Changelog doc/readme.html
	dodoc contrib/mimecut contrib/procmailrc
}
