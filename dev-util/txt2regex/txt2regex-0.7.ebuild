# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/txt2regex/txt2regex-0.7.ebuild,v 1.8 2004/06/25 02:49:15 agriffis Exp $

DESCRIPTION="A Regular Expression wizard that converts human sentences to regexs"
HOMEPAGE="http://txt2regex.sourceforge.net/"
SRC_URI="http://txt2regex.sourceforge.net/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 sparc mips ~alpha hppa ~amd64"
IUSE=""

RDEPEND=">=app-shells/bash-2.04"

src_install() {
	einstall DESTDIR=${D} MANDIR=${D}/usr/share/man/man1 || die
	dodoc Changelog NEWS README README.japanese TODO
	newman txt2regex.man txt2regex.6
}
