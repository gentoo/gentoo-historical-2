# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-mta/nbsmtp/nbsmtp-0.96.ebuild,v 1.3 2004/09/12 15:38:42 slarti Exp $

DESCRIPTION="Extremely simple MTA to get mail off the system to a relayhost"
SRC_URI="http://www.gentoo-es.org/~ferdy/${P}.tar.bz2"
HOMEPAGE="http://nbsmtp.ferdyx.org"

SLOT="0"
KEYWORDS="~x86 ~ppc ~hppa ~amd64"
LICENSE="GPL-2"
IUSE="ssl ipv6 debug"

DEPEND="virtual/libc
	ssl? ( dev-libs/openssl )"

PROVIDE="virtual/mta"

src_compile() {
	local myconf

	use ipv6 && myconf="${myconf} --enable-inet6"

	econf `use_enable ssl` \
		`use_enable debug` \
		${myconf} || die

	make || die
}

src_install() {
	dodir /usr/bin
	dobin nbsmtp
	doman nbsmtprc.5 nbsmtp.8
	dodoc INSTALL DOCS Doxyfile
}
