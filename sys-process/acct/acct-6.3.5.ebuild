# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/acct/acct-6.3.5.ebuild,v 1.2 2005/03/03 23:35:24 vapier Exp $

inherit eutils

MY_P=${P/-/_}
DESCRIPTION="GNU system accounting utilities"
HOMEPAGE="http://www.gnu.org/directory/acct.html"
SRC_URI="mirror://debian/pool/main/a/acct/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86 ppc"
IUSE=""

DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gentoo.diff
	rm -f ansi2knr.1
}

src_install() {
	dobin ac last lastcomm || die "dobin failed"
	dosbin dump-utmp dump-acct accton sa || die "dosbin failed"
	doinfo accounting.info
	doman *.[18]
	dodoc AUTHORS ChangeLog INSTALL NEWS README ToDo
	keepdir /var/account
	newinitd "${FILESDIR}"/acct.rc6 acct
}
