# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/emirror/emirror-2.1.21.ebuild,v 1.3 2004/03/19 10:08:21 mr_bones_ Exp $

DESCRIPTION="ECLiPt FTP mirroring tool"
HOMEPAGE="http://eclipt.uni-klu.ac.at/emirror.php"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=">=dev-lang/python-1.5"


src_compile() {
	./configure \
		--prefix=/usr \
		--sysconfdir=/etc \
		--mandir=/usr/share/man \
	|| die "configure problem"

	emake || die "compile problem"
}

src_install() {
	make \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man/man1 \
		sysconfdir=${D}/etc \
	install || die "install problem"
	dodoc doc/*
}
