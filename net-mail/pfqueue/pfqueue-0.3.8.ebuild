# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/pfqueue/pfqueue-0.3.8.ebuild,v 1.2 2005/06/13 23:28:58 ticho Exp $

inherit eutils
DESCRIPTION="pfqueue is an ncurses console-based tool for managing Postfix
queued messages"
HOMEPAGE="http://pfqueue.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""
DEPEND="virtual/libc"
RDEPEND="mail-mta/postfix"

src_install() {
	make DESTDIR=${D} install || die
	dodoc README ChangeLog COPYING
}
