# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/away/away-0.9.5.ebuild,v 1.3 2004/06/12 17:18:51 pyrania Exp $

DESCRIPTION="Terminal locking program with few additional features"
HOMEPAGE="http://unbeatenpath.net/software/away/"
SRC_URI="http://unbeatenpath.net/software/away/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc"
DEPEND="virtual/glibc"
RDEPEND=">=sys-libs/pam-0.75"
IUSE=""

src_unpack () {
	unpack ${A}
	sed -i "s:-O2:${CFLAGS}:" ${S}/Makefile
}
src_compile() {
	emake || die
}

src_install() {
	into /usr
	dobin away
	insinto /etc/pam.d ; newins data/away.pam away
	doman doc/*
	dodoc BUGS AUTHORS COPYING NEWS README TODO data/awayrc
}
