# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/acct/acct-6.3.5.ebuild,v 1.6 2004/06/11 12:23:21 kloeri Exp $

MY_P=${P/-/_}
S=${WORKDIR}/${P}
DESCRIPTION="GNU system accounting utilities"
SRC_URI="http://ftp.debian.org/debian/pool/main/a/acct/${MY_P}.orig.tar.gz"
HOMEPAGE="http://www.gnu.org/directory/acct.html"
KEYWORDS="x86 amd64 ~ppc alpha"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	cd ${S}

	patch -p0 < ${FILESDIR}/${PF}-gentoo.diff
}

src_install() {
	dobin ac last lastcomm
	dosbin dump-utmp dump-acct accton sa
	doinfo accounting.info
	doman *.[18]
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README ToDo
	dodir /var/account
	exeinto /etc/init.d
	newexe ${FILESDIR}/acct.rc6 acct
}
