# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/lpe/lpe-1.2.6.ebuild,v 1.7 2005/01/01 13:31:12 eradicator Exp $

inherit eutils

DESCRIPTION="Lightweight Programmers Editor"
HOMEPAGE="http://cdsmith.twu.net/professional/opensource/lpe.html"
SRC_URI="ftp://ftp.twu.net/users/cdsmith/lpe/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc ppc"
IUSE="nls"

DEPEND="sys-libs/slang"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-gentoo.patch
}

src_compile() {
	econf `use_enable nls` || die
	emake || die
}

src_install() {
	make \
		prefix=${D}/usr \
		datadir=${D}/usr/share \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		docdir=${D}/usr/share/doc/${PF} \
		exdir=${D}/usr/share/doc/${PF}/examples \
		install || die
	prepalldocs
}
