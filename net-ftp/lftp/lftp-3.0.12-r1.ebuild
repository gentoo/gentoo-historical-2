# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/lftp/lftp-3.0.12-r1.ebuild,v 1.6 2005/04/22 21:19:35 mrness Exp $

inherit eutils

DESCRIPTION="A sophisticated ftp/http client, file transfer program"
HOMEPAGE="http://ftp.yars.free.net/projects/lftp/"

#SRC_URI="http://the.wiretapped.net/mirrors/lftp/${P}.tar.bz2"
# Was a bit too slow and unreliable last time I tried (dragonheart)
SRC_URI="http://ftp.yars.free.net/pub/software/unix/net/ftp/client/lftp/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm hppa ~ia64 ~mips ppc ~ppc64 ~ppc-macos ~s390 sparc x86"
IUSE="ssl socks5 nls"

DEPEND=">=sys-libs/ncurses-5.1
	ssl? ( >=dev-libs/openssl-0.9.6 )
	socks5? ( >=net-proxy/dante-1.1.12 )
	nls? ( sys-devel/gettext )
	alpha? ( dev-lang/perl )
	alpha? ( >=sys-apps/sed-4 )
	virtual/libc
	sys-libs/readline
	socks5? ( sys-libs/pam )
	sys-apps/gawk
	sys-devel/bison
	sys-devel/libtool"

RDEPEND="nls? ( sys-devel/gettext )
	>=sys-libs/ncurses-5.1
	ssl? ( >=dev-libs/openssl-0.9.6 )
	virtual/libc
	sys-libs/readline
	socks5? ( sys-libs/pam )
	socks5? ( >=net-proxy/dante-1.1.12 )"

src_unpack() {
	unpack ${A}
	cd ${S}/src
	epatch ${FILESDIR}/${P}.patch || die 'patch failed'
}

src_compile() {
	local myconf="`use_enable nls`"

	use ssl && myconf="${myconf} --with-ssl=/usr" \
		|| myconf="${myconf} --without-ssl"

	use socks5 && myconf="${myconf} --with-socksdante=/usr" \
		|| myconf="${myconf} --without-socksdante"

	use ppc-macos && myconf="${myconf} --with-included-readline"

	econf \
		--sysconfdir=/etc/lftp \
		--without-modules \
		${myconf} || die "econf failed"

	emake || die "compile problem"
}

src_install() {
	emake install DESTDIR=${D} || die

	# hrmph, empty..
	rm -rf ${D}/usr/lib

	dodoc BUGS COPYING ChangeLog FAQ FEATURES MIRRORS \
		NEWS README* THANKS TODO
}
