# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/ircii/ircii-20030709-r2.ebuild,v 1.3 2003/10/28 13:08:09 todd Exp $

IUSE="ipv6"

DESCRIPTION="ircII is an IRC and ICB client that runs under most UNIX platforms."
SRC_URI="ftp://ircii.warped.com/pub/ircII/${P}.tar.bz2"
HOMEPAGE="http://www.eterna.com.au/ircii/"

DEPEND="sys-libs/ncurses
	>=sys-apps/sed-4"

RDEPEND="sys-libs/ncurses"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64 ~sparc"

src_compile() {

	# `use_with socks socks5` <- isn't socks5 working?
	econf `use_enable ipv6` || die
	emake || die "make failed"
}

src_install() {

	make DESTDIR=${D} install || die "make install failed"
	prepalldocs
	dodoc ChangeLog INSTALL NEWS README
	dodoc doc/Copyright doc/crypto doc/VERSIONS doc/ctcp
}
