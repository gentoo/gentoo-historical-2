# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/konversation/konversation-0.14.ebuild,v 1.3 2005/01/19 22:44:03 swegener Exp $

inherit kde

DESCRIPTION="A user friendly IRC Client for KDE3.x"
HOMEPAGE="http://konversation.sourceforge.net"
SRC_URI="mirror://sourceforge/konversation/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="nls"

need-kde 3

src_install() {
	kde_src_install
	use nls || rm -rf ${D}/usr/share/locale
}
