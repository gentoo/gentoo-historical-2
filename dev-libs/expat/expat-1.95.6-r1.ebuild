# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/expat/expat-1.95.6-r1.ebuild,v 1.9 2003/09/17 19:14:45 avenj Exp $

inherit eutils

DESCRIPTION="XML parsing libraries"
SRC_URI="mirror://sourceforge/expat/${P}.tar.gz"
HOMEPAGE="http://expat.sourceforge.net/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="amd64 x86 ~ppc sparc alpha hppa arm ia64"

DEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	cd ${S}/lib
	epatch ${FILESDIR}/xmlstatus.patch
}

src_compile() {
	econf || die
	# parallel make doesnt work
	make || die
}

src_install() {
	einstall mandir=${D}/usr/share/man/man1
	dodoc COPYING Changes MANIFEST README
	dohtml doc/*
}
