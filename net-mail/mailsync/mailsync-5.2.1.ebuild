# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/mailsync/mailsync-5.2.1.ebuild,v 1.3 2005/07/28 08:51:50 dholm Exp $

DESCRIPTION="A mailbox synchronizer"
HOMEPAGE="http://mailsync.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}.orig.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"

IUSE=""

DEPEND="virtual/imap-c-client"

src_install() {
	make DESTDIR=${D} install pkgdocdir=/usr/share/doc/${P} || die
	doman doc/mailsync.1
}
