# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/librvp/librvp-0.9.6.ebuild,v 1.1 2007/06/18 23:30:06 tester Exp $

inherit multilib

DESCRIPTION="An RVP (Microsoft Exchange Instant Messaging) plugin for Pidgin"
HOMEPAGE="http://www.waider.ie/hacks/workshop/c/rvp/"
SRC_URI="http://www.waider.ie/hacks/workshop/c/rvp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-im/pidgin"

src_compile() {

	econf --with-gaim-plugin-dir=/usr/$(get_libdir)/pidgin \
		--with-gaim-data-dir=/usr/share/pixmaps/pidgin \
		|| die "configure failed"

	emake || die "make failure"
}

src_install() {
	make install DESTDIR=${D} || die "install failure"
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README rvp_protocol.txt
}
