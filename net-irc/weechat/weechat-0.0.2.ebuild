# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/weechat/weechat-0.0.2.ebuild,v 1.1 2003/10/17 02:20:10 zul Exp $

DESCRIPTION="Portable and multi-interface IRC client."
HOMEPAGE="http://weechat.flashtux.org/"
SRC_URI="http://weechat.flashtux.org/download/${P}.tar.bz2"
LICENSE="GPL-2"


SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="sys-libs/ncurses"
RDEPEND=""

S=${WORKDIR}/${P}

src_compile() {
	emake || die
}

src_install() {
	einstall DESTDIR=${D} || die
	dodoc AUTHORS BUGS COPYING README
}
