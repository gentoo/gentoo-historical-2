# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/konversation/konversation-0.9.ebuild,v 1.3 2003/02/15 07:50:38 gerk Exp $

IUSE="nls"

inherit kde-base
need-kde 3

DESCRIPTION="A user friendly IRC Client for KDE3.x"
HOMEPAGE="http://konversation.sourceforge.net"
SRC_URI="http://konversation.sourceforge.net/downloads/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"

src_compile() {

	rm configure

	need-autoconf 2.1
	need-automake 1.4

	kde_src_compile
}

src_install() {
	
	kde_src_install

	use nls || rm -rf ${D}/usr/share/locale
}
