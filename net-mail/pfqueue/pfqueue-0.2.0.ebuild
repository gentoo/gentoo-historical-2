# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/pfqueue/pfqueue-0.2.0.ebuild,v 1.2 2005/01/22 21:45:40 ticho Exp $

inherit eutils
DESCRIPTION="pfqueue is an ncurses console-based tool for managing Postfix
queued messages"
HOMEPAGE="http://pfqueue.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="virtual/libc"
RDEPEND="mail-mta/postfix"

src_install() {
	dosbin pfqueue
	dodoc README ChangeLog
}

pkg_postinst() {
	einfo "Start this program (as root) with pfqueue"
	einfo ""
	einfo "To delete messages from the queue press 'd' and then 'y'"
	einfo "To quit type 'q'"
}
